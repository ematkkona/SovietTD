# ===========================================
# MISSILE STATION TOWER
# Path: scripts/towers/MissileStation.gd
# Heavy damage, slow fire rate tower
# ===========================================
extends BaseTower

func initialize_tower():
	print("⚙️ MissileStation.initialize_tower() called")
	tower_name = "Missile Station"
	tower_cost = 300
	damage = 100
	urange = 250.0
	fire_rate = 0.5

func _ready():
	print("⚙️ MissileStation._ready() called")
	super()  # Call parent _ready() first

	if sprite:
		sprite.texture = PixelArtHelper.create_missile_station_sprite()
	print("✅ MissileStation fully initialized")

func create_projectile() -> Node2D:
	var bullet = preload("res://scenes/projectiles/Bullet.tscn").instantiate()
	bullet.global_position = gun_barrel.global_position if gun_barrel else global_position
	bullet.setup_projectile(current_target, damage)

	# Set faster missile speed
	bullet.speed = 600.0

	# Mark as missile for explosion effect
	bullet.is_missile = true

	# Make missile larger and red
	if bullet.sprite:
		bullet.sprite.texture = create_placeholder_texture(Color.RED, Vector2(8, 8))

	print("🚀 Missile launched!")
	return bullet
