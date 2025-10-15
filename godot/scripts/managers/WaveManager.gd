# ===========================================
# 2. AUTOLOAD: WaveManager.gd
# Path: scripts/autoloads/WaveManager.gd
# ===========================================
extends Node

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal enemy_spawned(enemy: Node2D)
signal all_waves_completed

var current_wave: int = 0
var total_waves: int = 6
var enemies_in_wave: int = 0
var enemies_remaining: int = 0
var wave_active: bool = false

var spawn_timer: Timer
var enemy_spawn_point: Vector2 = Vector2.ZERO
var enemy_path: Path2D = null

var wave_data: Array[Dictionary] = []

func _ready():
	print("🌊 WaveManager initialized")
	
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_spawn_next_enemy)
	
	load_wave_configuration()

func load_wave_configuration():
	wave_data = [
		{"wave": 1, "enemies": [{"type": "Businessman", "count": 5, "interval": 2.0}]},
		{"wave": 2, "enemies": [{"type": "Businessman", "count": 8, "interval": 1.5}]},
		{"wave": 3, "enemies": [
			{"type": "Businessman", "count": 5, "interval": 1.5},
			{"type": "Tourist", "count": 3, "interval": 1.0}
		]},
		{"wave": 4, "enemies": [{"type": "Tourist", "count": 10, "interval": 1.2}]},
		{"wave": 5, "enemies": [
			{"type": "Businessman", "count": 6, "interval": 1.0},
			{"type": "Tourist", "count": 6, "interval": 1.0}
		]},
		{"wave": 6, "enemies": [{"type": "CEO", "count": 1, "interval": 5.0}]}
	]
	total_waves = wave_data.size()

func setup_for_level(level_node: Node2D):
	if not level_node:
		return
		
	var paths = level_node.find_children("*", "Path2D", false, false)
	if paths.size() > 0:
		enemy_path = paths[0]
		print("📍 Enemy path found")

func start_next_wave():
	if wave_active or current_wave >= total_waves:
		return
	
	current_wave += 1
	var wave_config = wave_data[current_wave - 1]
	
	print("🚨 Starting wave ", current_wave)
	
	enemies_in_wave = 0
	for enemy_group in wave_config.enemies:
		enemies_in_wave += enemy_group.count
	
	enemies_remaining = enemies_in_wave
	wave_active = true
	
	wave_started.emit(current_wave)
	_start_spawning_wave(wave_config)

func _start_spawning_wave(wave_config: Dictionary):
	var spawn_queue: Array[Dictionary] = []
	
	for enemy_group in wave_config.enemies:
		for i in enemy_group.count:
			spawn_queue.append({
				"type": enemy_group.type,
				"delay": enemy_group.interval
			})
	
	spawn_queue.shuffle()
	_spawn_from_queue(spawn_queue)

func _spawn_from_queue(queue: Array[Dictionary]):
	if queue.is_empty():
		return
	
	var enemy_data = queue.pop_front()
	_spawn_enemy(enemy_data.type)
	
	if not queue.is_empty():
		spawn_timer.wait_time = enemy_data.delay
		spawn_timer.start()
		spawn_timer.timeout.connect(_spawn_from_queue.bind(queue), CONNECT_ONE_SHOT)

func _spawn_enemy(enemy_type: String):
	var enemy_scene_path = "res://scenes/enemies/" + enemy_type + ".tscn"
	
	if not ResourceLoader.exists(enemy_scene_path):
		print("❌ Enemy scene not found: ", enemy_scene_path)
		return
	
	var enemy_scene = load(enemy_scene_path)
	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = enemy_spawn_point
	if enemy_path:
		enemy.set_path(enemy_path)
	
	enemy.enemy_died.connect(_on_enemy_died)
	enemy.enemy_reached_end.connect(_on_enemy_reached_end)
	
	enemy_spawned.emit(enemy)
	print("👔 Spawned ", enemy_type)

func _spawn_next_enemy():
	pass

func _on_enemy_died(enemy: Node2D):
	enemies_remaining -= 1
	print("💀 Enemy died. Remaining: ", enemies_remaining, " / ", enemies_in_wave)
	_check_wave_completion()

func _on_enemy_reached_end(enemy: Node2D):
	enemies_remaining -= 1
	print("🏁 Enemy reached end. Remaining: ", enemies_remaining, " / ", enemies_in_wave)
	EconomyManager.lose_life()
	_check_wave_completion()

func _check_wave_completion():
	print("🔍 Check wave: remaining=", enemies_remaining, " active=", wave_active)
	if enemies_remaining <= 0 and wave_active:
		wave_active = false
		print("✅ Wave ", current_wave, " completed!")

		EventBus.wave_completed.emit(current_wave)

		if current_wave >= total_waves:
			print("🏆 All waves completed!")
			all_waves_completed.emit()

func is_wave_active() -> bool:
	return wave_active

func get_current_wave() -> int:
	return current_wave

func get_total_waves() -> int:
	return total_waves
