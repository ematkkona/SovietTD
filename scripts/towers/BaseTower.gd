# ===========================================
# 7. BASE TOWER CLASS
# Path: scripts/towers/BaseTower.gd
# ===========================================
extends Node2D
class_name BaseTower

signal tower_upgraded(new_level: int)

@export var tower_name: String = "Base Tower"
@export var tower_cost: int = 100
@export var damage: int = 25
@export var urange: float = 200.0
@export var fire_rate: float = 1.0
@export var tower_level: int = 1
@export var max_level: int = 3

var current_target: Node2D = null
var enemies_in_range: Array[Node2D] = []
var can_fire: bool = true

var fire_timer: Timer
var urange_area: Area2D
var sprite: Sprite2D
var gun_barrel: Marker2D

func _ready():
	print("⚙️ BaseTower._ready() called")
	initialize_tower()
	print("🏗️ ", tower_name, " constructed! Range: ", urange, " Damage: ", damage)

	setup_tower_components()
	setup_targeting_system()
	print("✅ Tower setup complete. Range area radius: ", urange_area.get_child(0).shape.radius if urange_area else 0)

# Override this in child towers to set stats
func initialize_tower():
	print("⚙️ BaseTower.initialize_tower() called (default - should be overridden)")

func setup_tower_components():
	sprite = Sprite2D.new()
	sprite.texture = create_placeholder_texture(Color.GRAY, Vector2(32, 32))
	add_child(sprite)
	
	gun_barrel = Marker2D.new()
	gun_barrel.name = "GunBarrel"
	add_child(gun_barrel)
	
	fire_timer = Timer.new()
	fire_timer.wait_time = 1.0 / fire_rate
	fire_timer.one_shot = true
	add_child(fire_timer)
	fire_timer.timeout.connect(_on_fire_timer_timeout)

func setup_targeting_system():
	urange_area = Area2D.new()
	urange_area.name = "RangeArea"
	add_child(urange_area)
	
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = urange
	collision_shape.shape = circle_shape
	urange_area.add_child(collision_shape)
	
	urange_area.body_entered.connect(_on_enemy_entered_range)
	urange_area.body_exited.connect(_on_enemy_exited_range)
	
	urange_area.collision_layer = 0
	urange_area.collision_mask = 2

func _process(_delta):
	if current_target and is_instance_valid(current_target):
		if is_target_in_range(current_target):
			aim_at_target(current_target)
			try_fire_at_target()
		else:
			current_target = null
	
	if not current_target:
		find_new_target()

func find_new_target():
	if enemies_in_range.is_empty():
		return
	enemies_in_range = enemies_in_range.filter(func(enemy): return is_instance_valid(enemy))
	if enemies_in_range.is_empty():
		return
	current_target = get_first_enemy()

func get_first_enemy() -> Node2D:
	var best_enemy = null
	var best_progress = -1.0
	
	for enemy in enemies_in_range:
		if enemy.has_method("get_path_progress"):
			var progress = enemy.get_path_progress()
			if progress > best_progress:
				best_progress = progress
				best_enemy = enemy
	
	return best_enemy if best_enemy else enemies_in_range[0]

func is_target_in_range(target: Node2D) -> bool:
	return global_position.distance_to(target.global_position) <= urange

func aim_at_target(target: Node2D):
	if gun_barrel and target:
		var angle = global_position.angle_to_point(target.global_position)
		gun_barrel.rotation = angle

func try_fire_at_target():
	if can_fire and current_target:
		fire_projectile()

func fire_projectile():
	can_fire = false
	fire_timer.start()
	
	var projectile = create_projectile()
	if projectile:
		get_tree().current_scene.add_child(projectile)
		print("🔫 Tower fired!")

func create_projectile() -> Node2D:
	var bullet = preload("res://scenes/projectiles/Bullet.tscn").instantiate()
	bullet.global_position = gun_barrel.global_position if gun_barrel else global_position
	bullet.setup_projectile(current_target, damage)
	return bullet

func upgrade_tower() -> bool:
	if tower_level >= max_level:
		return false
	
	var upgrade_cost = 150
	if not EconomyManager.can_afford(upgrade_cost):
		return false
	
	if EconomyManager.spend_rubles(upgrade_cost):
		tower_level += 1
		damage = int(damage * 1.5)
		tower_upgraded.emit(tower_level)
		print("⬆️ Tower upgraded to level ", tower_level)
		return true
	
	return false

func _on_enemy_entered_range(body: Node2D):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)
		print("🎯 ", tower_name, ": Enemy entered range. Total in range: ", enemies_in_range.size())

func _on_enemy_exited_range(body: Node2D):
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)
		print("🎯 ", tower_name, ": Enemy exited range. Total in range: ", enemies_in_range.size())
		if current_target == body:
			current_target = null

func _on_fire_timer_timeout():
	can_fire = true

func create_placeholder_texture(color: Color, size: Vector2) -> ImageTexture:
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
