# ===========================================
# 11. BUSINESSMAN ENEMY
# Path: scripts/enemies/Businessman.gd
# ===========================================
extends BaseEnemy

func _ready():
	enemy_name = "Businessman"
	max_health = 80
	movement_speed = 60.0
	rubles_reward = 15
	
	super()
	
	if sprite:
		sprite.texture = create_placeholder_texture(Color.DARK_BLUE, Vector2(16, 24))
