# ===========================================
# 10. BASE ENEMY CLASS
# Path: scripts/enemies/BaseEnemy.gd
# ===========================================
extends CharacterBody2D
class_name BaseEnemy

signal enemy_died(enemy: BaseEnemy)
signal enemy_reached_end(enemy: BaseEnemy)

@export var enemy_name: String = "Base Enemy"
@export var max_health: int = 100
@export var movement_speed: float = 50.0
@export var rubles_reward: int = 15

var current_health: int
var base_speed: float
var current_speed_modifier: float = 1.0
var slow_effects: Array[Dictionary] = []

var path_follow: PathFollow2D
var enemy_path: Path2D

var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var is_dying: bool = false

func _ready():
	print("👔 ", enemy_name, " spawned!")
	
	current_health = max_health
	base_speed = movement_speed
	
	setup_enemy_components()
	add_to_group("enemies")
	
	collision_layer = 2
	collision_mask = 0

func setup_enemy_components():
	animated_sprite = AnimatedSprite2D.new()
	add_child(animated_sprite)

	collision_shape = CollisionShape2D.new()
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(16, 24)
	collision_shape.shape = rect_shape
	add_child(collision_shape)

# Helper function for child classes to setup their animations
func setup_animations(walk_frames: Array[ImageTexture], death_frames: Array[ImageTexture]):
	var sprite_frames = SpriteFrames.new()

	# Setup walk animation
	sprite_frames.add_animation("walk")
	sprite_frames.set_animation_loop("walk", true)
	sprite_frames.set_animation_speed("walk", 6.0)  # 6 FPS for walk cycle
	for frame in walk_frames:
		sprite_frames.add_frame("walk", frame)

	# Setup death animation
	sprite_frames.add_animation("death")
	sprite_frames.set_animation_loop("death", false)
	sprite_frames.set_animation_speed("death", 4.0)  # 4 FPS for death (slower, more dramatic)
	for frame in death_frames:
		sprite_frames.add_frame("death", frame)

	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.play("walk")  # Start with walking animation

func set_path(new_path: Path2D):
	enemy_path = new_path
	
	path_follow = PathFollow2D.new()
	path_follow.loop = false
	enemy_path.add_child(path_follow)
	
	global_position = path_follow.global_position

func _physics_process(delta):
	if path_follow and enemy_path:
		move_along_path(delta)
	
	update_slow_effects(delta)

func move_along_path(delta):
	var effective_speed = movement_speed * current_speed_modifier
	path_follow.progress += effective_speed * delta
	
	global_position = path_follow.global_position
	
	if path_follow.progress_ratio >= 1.0:
		reach_end()

func take_damage(damage_amount: int, _damage_source: Node2D = null):
	current_health -= damage_amount
	current_health = max(current_health, 0)

	print("💥 ", enemy_name, " takes ", damage_amount, " damage")

	if current_health <= 0:
		die()

func die():
	if is_dying:
		return  # Already dying, prevent double-trigger

	is_dying = true
	print("☠️ ", enemy_name, " eliminated!")

	EconomyManager.reward_kill(enemy_name)

	# Play death animation if available
	if animated_sprite and animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("death"):
		animated_sprite.play("death")

		# Wait for death animation to finish
		await animated_sprite.animation_finished

		# Fade out effect
		var tween = create_tween()
		tween.tween_property(animated_sprite, "modulate:a", 0.0, 0.3)
		await tween.finished

	if path_follow:
		path_follow.queue_free()

	enemy_died.emit(self)
	queue_free()

func reach_end():
	print("🚨 ", enemy_name, " reached base!")
	
	EconomyManager.lose_life()
	
	enemy_reached_end.emit(self)
	
	if path_follow:
		path_follow.queue_free()
	queue_free()

func apply_slow_effect(slow_strength: float, duration: float):
	var effect = {
		"strength": slow_strength,
		"duration": duration,
		"time_left": duration
	}
	slow_effects.append(effect)
	update_speed_modifier()

func update_slow_effects(delta):
	for i in range(slow_effects.size() - 1, -1, -1):
		slow_effects[i].time_left -= delta
		if slow_effects[i].time_left <= 0:
			slow_effects.remove_at(i)
	
	update_speed_modifier()

func update_speed_modifier():
	current_speed_modifier = 1.0
	
	for effect in slow_effects:
		var slow_factor = 1.0 - effect.strength
		current_speed_modifier = min(current_speed_modifier, slow_factor)
	
	current_speed_modifier = max(current_speed_modifier, 0.1)

func get_health() -> int:
	return current_health

func get_path_progress() -> float:
	if path_follow:
		return path_follow.progress_ratio
	return 0.0

func create_placeholder_texture(color: Color, size: Vector2) -> ImageTexture:
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
