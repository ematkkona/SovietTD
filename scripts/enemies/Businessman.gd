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
		sprite.texture = PixelArtHelper.create_businessman_sprite()
