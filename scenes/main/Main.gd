# ===========================================
# 16. MAIN GAME SCENE SCRIPT
# Path: scenes/main/Main.gd
# ===========================================
extends Node2D

@onready var game_world = $GameWorld
@onready var level_container = $GameWorld/Level
@onready var camera = $GameWorld/Camera

var selected_tower_type: String = ""
var tower_placement_mode: bool = false

func _ready():
	print("🚩 Main game scene loaded!")
	
	setup_game_scene()
	load_current_level()
	
	EventBus.ui_tower_selected.connect(_on_ui_tower_selected)

func setup_game_scene():
	camera.enabled = true
	#camera.current = true
	camera.zoom = Vector2(0.8, 0.8)
	
	WaveManager.enemy_spawned.connect(_on_enemy_spawned)

func load_current_level():
	create_test_level()

func create_test_level():
	var path = Path2D.new()
	path.name = "EnemyPath"
	
	var curve = Curve2D.new()
	curve.add_point(Vector2(0, 540))
	curve.add_point(Vector2(1920, 540))
	path.curve = curve
	
	level_container.add_child(path)
	
	WaveManager.enemy_spawn_point = Vector2(0, 540)
	WaveManager.enemy_path = path
	
	print("✅ Test level created")

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if tower_placement_mode and selected_tower_type != "":
			var world_pos = get_global_mouse_position()
			attempt_tower_placement(world_pos)

func _on_ui_tower_selected(tower_type: String):
	selected_tower_type = tower_type
	tower_placement_mode = true
	print("🏗️ Selected tower: ", tower_type)

func attempt_tower_placement(click_pos: Vector2):
	var validation = is_valid_tower_position(click_pos)
	if not validation:
		print("❌ Invalid tower position at ", click_pos)
		# Don't clear selection on invalid placement - let user try again
		return

	var tower_cost = get_tower_cost(selected_tower_type)

	if not EconomyManager.can_afford(tower_cost):
		print("❌ Cannot afford tower (need ", tower_cost, "₽)")
		# Don't clear selection if can't afford - let user wait for money
		return

	if EconomyManager.spend_rubles(tower_cost):
		place_tower(selected_tower_type, click_pos)
		# Clear selection after successful placement
		tower_placement_mode = false
		selected_tower_type = ""
		print("✅ Tower placed successfully! Click button again to place another.")

func place_tower(tower_type: String, tower_pos: Vector2):
	var tower_scene_path = "res://scenes/towers/" + tower_type + ".tscn"

	if not ResourceLoader.exists(tower_scene_path):
		print("❌ Tower scene not found")
		return

	var tower_scene = load(tower_scene_path)
	var tower = tower_scene.instantiate()

	tower.global_position = tower_pos
	level_container.add_child(tower)

	print("🏗️ Placed ", tower_type, " at ", tower_pos)

func is_valid_tower_position(check_pos: Vector2) -> bool:
	# Check if within playable area
	var level_bounds = Rect2(50, 50, 1820, 980)
	if not level_bounds.has_point(check_pos):
		print("⚠️ Position outside level bounds")
		return false

	# Check if too close to enemy path (y=540, give 50px clearance instead of 100)
	if abs(check_pos.y - 540) < 50:
		print("⚠️ Too close to enemy path")
		return false

	# Check if overlapping with existing towers
	var min_tower_distance = 40.0  # Minimum distance between towers
	for child in level_container.get_children():
		if child is BaseTower:
			if child.global_position.distance_to(check_pos) < min_tower_distance:
				print("⚠️ Too close to another tower")
				return false

	return true

func get_tower_cost(tower_type: String) -> int:
	var costs = {
		"GuardTower": 100,
		"PropagandaSpeaker": 150,
		"BureaucraticOffice": 200,
		"MissileStation": 300
	}
	return costs.get(tower_type, 100)

func _on_enemy_spawned(enemy: Node2D):
	level_container.add_child(enemy)
