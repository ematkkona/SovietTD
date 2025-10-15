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
		sprite.texture = PixelArtHelper.create_ceo_sprite()
		# CEO is already bigger (24x32 vs 16x24), no extra scaling needed
