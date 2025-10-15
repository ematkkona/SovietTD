# ===========================================
# 12. TOURIST ENEMY
# Path: scripts/enemies/Tourist.gd
# ===========================================
extends BaseEnemy

func _ready():
	enemy_name = "Tourist"
	max_health = 50
	movement_speed = 90.0
	rubles_reward = 12
	
	super()
	
	if sprite:
		sprite.texture = PixelArtHelper.create_tourist_sprite()
