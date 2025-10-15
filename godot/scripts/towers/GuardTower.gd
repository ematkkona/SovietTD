# ===========================================
# 8. GUARD TOWER
# Path: scripts/towers/GuardTower.gd
# ===========================================
extends BaseTower

func initialize_tower():
	tower_name = "Guard Tower"
	tower_cost = 100
	damage = 25
	urange = 200.0
	fire_rate = 1.5

func _ready():
	super()  # Calls parent's _ready() which calls initialize_tower()

	# Customize sprite color after parent setup
	if sprite:
		sprite.texture = create_placeholder_texture(Color.DARK_GREEN, Vector2(32, 32))
