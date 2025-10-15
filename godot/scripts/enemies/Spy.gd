# ===========================================
# 13. SPY ENEMY
# Path: scripts/enemies/Spy.gd
# ===========================================
extends BaseEnemy

func _ready():
	enemy_name = "Spy"
	max_health = 120
	movement_speed = 45.0
	rubles_reward = 25
	
	super()
	
	if sprite:
		sprite.texture = create_placeholder_texture(Color.DARK_GRAY, Vector2(16, 24))
