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

	# Setup animations
	var walk_frames: Array[ImageTexture] = [
		PixelArtHelper.create_tourist_walk_frame1(),
		PixelArtHelper.create_tourist_walk_frame2()
	]
	var death_frames = PixelArtHelper.create_tourist_death_frames()
	setup_animations(walk_frames, death_frames)
