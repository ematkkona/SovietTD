extends Node

## AudioEventHandler - Centralized Audio Response to Game Events
##
## This autoload connects to EventBus signals and triggers appropriate audio feedback.
## Keeps audio logic decoupled from game systems while maintaining event-driven architecture.

func _ready():
	print("🔊 AudioEventHandler initialized")

	# Connect to EventBus signals for audio feedback
	connect_wave_events()
	connect_tower_events()
	connect_game_events()

func connect_wave_events():
	"""Connect to wave-related events"""
	if EventBus.has_signal("wave_started"):
		EventBus.wave_started.connect(_on_wave_started)

	if EventBus.has_signal("wave_completed"):
		EventBus.wave_completed.connect(_on_wave_completed)

func connect_tower_events():
	"""Connect to tower-related events"""
	if EventBus.has_signal("tower_placed"):
		EventBus.tower_placed.connect(_on_tower_placed)

	if EventBus.has_signal("tower_upgraded"):
		EventBus.tower_upgraded.connect(_on_tower_upgraded)

	if EventBus.has_signal("tower_sold"):
		EventBus.tower_sold.connect(_on_tower_sold)

func connect_game_events():
	"""Connect to game state events"""
	if EventBus.has_signal("game_paused"):
		EventBus.game_paused.connect(_on_game_paused)

	if EventBus.has_signal("level_completed"):
		EventBus.level_completed.connect(_on_level_completed)

	if EventBus.has_signal("game_over"):
		EventBus.game_over.connect(_on_game_over)

# =============================================================================
# EVENT HANDLERS
# =============================================================================

func _on_wave_started(wave_number: int):
	"""Play wave start sound and optional voice line"""
	print("🔊 Audio: Wave ", wave_number, " started")
	AudioManager.play_sfx_resource(AudioRegistry.SFX_WAVE_START)

	# TODO: Play dramatic voice line every 3rd wave
	# if wave_number % 3 == 0 and AudioRegistry.VOICE_WAVE_INCOMING:
	#     await get_tree().create_timer(0.5).timeout  # Delay voice slightly
	#     AudioManager.play_sfx_resource(AudioRegistry.VOICE_WAVE_INCOMING)

func _on_wave_completed(wave_number: int):
	"""Play wave completion fanfare"""
	print("🔊 Audio: Wave ", wave_number, " completed")
	AudioManager.play_sfx_resource(AudioRegistry.SFX_WAVE_COMPLETE)

func _on_tower_placed(tower: Node2D, position: Vector2):
	"""Play tower placement sound"""
	print("🔊 Audio: Tower placed at ", position)
	AudioManager.play_sfx_resource(AudioRegistry.SFX_TOWER_PLACE)

	# TODO: Play construction voice line occasionally
	# if randf() < 0.3 and AudioRegistry.VOICE_TOWER_BUILT:
	#     await get_tree().create_timer(0.3).timeout
	#     AudioManager.play_sfx_resource(AudioRegistry.VOICE_TOWER_BUILT, 0.7)

func _on_tower_upgraded(tower: Node2D, new_level: int):
	"""Play tower upgrade sound"""
	print("🔊 Audio: Tower upgraded to level ", new_level)
	# TODO: Implement when SFX_TOWER_UPGRADE is created
	# AudioManager.play_sfx_resource(AudioRegistry.SFX_TOWER_UPGRADE)

func _on_tower_sold(tower: Node2D, refund_amount: int):
	"""Play tower sell sound"""
	print("🔊 Audio: Tower sold for ", refund_amount, " rubles")
	# TODO: Implement when SFX_TOWER_SELL is created
	# AudioManager.play_sfx_resource(AudioRegistry.SFX_TOWER_SELL)

func _on_game_paused(paused: bool):
	"""Duck audio volume when game is paused"""
	if paused:
		AudioManager.set_master_volume(0.3)  # Duck to 30%
		print("🔊 Audio: Ducked (game paused)")
	else:
		AudioManager.set_master_volume(1.0)  # Restore to 100%
		print("🔊 Audio: Restored (game resumed)")

func _on_level_completed():
	"""Play victory fanfare"""
	print("🔊 Audio: Level completed")
	# TODO: Stop gameplay music and play victory fanfare
	# AudioManager.stop_music()
	# AudioManager.play_music_resource(AudioRegistry.MUSIC_VICTORY, false)

func _on_game_over():
	"""Handle game over audio"""
	print("🔊 Audio: Game over")
	# TODO: Stop music and play game over sound
	# AudioManager.stop_music()
