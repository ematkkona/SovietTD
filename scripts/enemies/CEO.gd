# ===========================================
# 14. CEO BOSS
# Path: scripts/enemies/CEO.gd
# ===========================================
extends BaseEnemy

func _ready():
	enemy_name = "CEO Boss"
	max_health = 500
	movement_speed = 30.0
	rubles_reward = 100
	
	super()
	
	if sprite:
		sprite.texture = create_placeholder_texture(Color.GOLD, Vector2(24, 32))
		sprite.scale = Vector2(1.5, 1.5)
