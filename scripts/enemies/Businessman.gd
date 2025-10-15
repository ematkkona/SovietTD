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

	# Setup animations
	var walk_frames: Array[ImageTexture] = [
		PixelArtHelper.create_businessman_walk_frame1(),
		PixelArtHelper.create_businessman_walk_frame2()
	]
	var death_frames = PixelArtHelper.create_businessman_death_frames()
	setup_animations(walk_frames, death_frames)
