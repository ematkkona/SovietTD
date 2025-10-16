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

	# Setup animations
	var walk_frames: Array[ImageTexture] = [
		PixelArtHelper.create_spy_walk_frame1(),
		PixelArtHelper.create_spy_walk_frame2()
	]
	var death_frames = PixelArtHelper.create_spy_death_frames()
	setup_animations(walk_frames, death_frames)
