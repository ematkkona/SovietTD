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
		body.take_damage(damage, self)
		queue_free()

func create_placeholder_texture(color: Color, size: Vector2) -> ImageTexture:
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
