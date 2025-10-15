# ===========================================
# 15. PROJECTILE (BULLET)
# Path: scripts/projectiles/Bullet.gd
# ===========================================
extends Area2D

var target: Node2D
var damage: int = 25
var speed: float = 400.0
var direction: Vector2
var sprite: Sprite2D
var is_missile: bool = false  # Flag to trigger explosion effect

func _ready():
	collision_layer = 4
	collision_mask = 2
	
	sprite = Sprite2D.new()
	sprite.texture = create_placeholder_texture(Color.YELLOW, Vector2(4, 4))
	add_child(sprite)
	
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = 4
	collision_shape.shape = circle_shape
	add_child(collision_shape)
	
	body_entered.connect(_on_body_entered)

func setup_projectile(target_enemy: Node2D, projectile_damage: int):
	target = target_enemy
	damage = projectile_damage
	
	if target:
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()

func _physics_process(delta):
	if target and is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()
	
	global_position += direction * speed * delta
	
	var screen_rect = get_viewport_rect()
	if not screen_rect.has_point(global_position):
		queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		# Create explosion effect if this is a missile
		if is_missile:
			create_explosion_effect()

		body.take_damage(damage, self)
		queue_free()

func create_explosion_effect():
	# Create explosion at impact point
	var explosion = Node2D.new()
	get_parent().add_child(explosion)
	explosion.global_position = global_position

	# Create multiple expanding circles for explosion
	for i in range(4):
		var circle = Node2D.new()
		explosion.add_child(circle)

		var circle_sprite = Sprite2D.new()
		# Colors: bright yellow/orange core to red outer rings
		var colors = [
			Color(1, 1, 0.8, 0.9),    # Bright yellow core
			Color(1, 0.7, 0.2, 0.8),  # Orange
			Color(1, 0.3, 0, 0.7),    # Red-orange
			Color(0.6, 0.1, 0, 0.5)   # Dark red
		]
		circle_sprite.texture = create_explosion_circle(15 + i * 10, colors[i])
		circle.add_child(circle_sprite)

		# Animate explosion
		var tween = create_tween()
		tween.set_parallel(true)

		# Expand rapidly then dissipate
		var start_scale = 0.2 + i * 0.1
		var end_scale = 2.5 + i * 0.3
		tween.tween_property(circle, "scale", Vector2(end_scale, end_scale), 0.6).from(Vector2(start_scale, start_scale))

		# Fade out
		tween.tween_property(circle_sprite, "modulate:a", 0.0, 0.5).set_delay(0.1)

		# Slight delay between rings
		await get_tree().create_timer(0.05).timeout

	# Add some debris particles
	for i in range(8):
		var debris = Node2D.new()
		explosion.add_child(debris)

		var debris_sprite = Sprite2D.new()
		debris_sprite.texture = create_debris_texture()
		debris.add_child(debris_sprite)

		# Random direction
		var angle = (i / 8.0) * TAU + randf_range(-0.2, 0.2)
		var distance = randf_range(30, 60)
		var end_pos = Vector2(cos(angle), sin(angle)) * distance

		var debris_tween = create_tween()
		debris_tween.set_parallel(true)
		debris_tween.tween_property(debris, "position", end_pos, 0.5)
		debris_tween.tween_property(debris, "rotation", randf_range(-TAU, TAU), 0.5)
		debris_tween.tween_property(debris_sprite, "modulate:a", 0.0, 0.4).set_delay(0.1)

	# Clean up explosion after animation
	await get_tree().create_timer(0.7).timeout
	explosion.queue_free()

func create_explosion_circle(radius: int, color: Color) -> ImageTexture:
	var size = radius * 2 + 4
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)

	var center = Vector2(size / 2, size / 2)

	# Draw filled circle
	for x in range(size):
		for y in range(size):
			var dist = center.distance_to(Vector2(x, y))
			if dist <= radius:
				# Gradient from center to edge
				var alpha = color.a * (1.0 - (dist / radius) * 0.5)
				var pixel_color = Color(color.r, color.g, color.b, alpha)
				image.set_pixel(x, y, pixel_color)

	return ImageTexture.create_from_image(image)

func create_debris_texture() -> ImageTexture:
	var size = 6
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)

	# Small debris particles (gray/black)
	var debris_color = Color(0.3, 0.3, 0.3, 0.8)
	for x in range(1, size - 1):
		for y in range(1, size - 1):
			if randf() > 0.3:  # Irregular shape
				image.set_pixel(x, y, debris_color)

	return ImageTexture.create_from_image(image)

func create_placeholder_texture(color: Color, size: Vector2) -> ImageTexture:
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
