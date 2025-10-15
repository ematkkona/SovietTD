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

	# Setup animations
	var walk_frames: Array[ImageTexture] = [
		PixelArtHelper.create_ceo_walk_frame1(),
		PixelArtHelper.create_ceo_walk_frame2()
	]
	var death_frames = PixelArtHelper.create_ceo_death_frames()
	setup_animations(walk_frames, death_frames)
