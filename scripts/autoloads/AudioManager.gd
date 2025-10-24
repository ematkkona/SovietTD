# ===========================================
# AUTOLOAD: AudioManager.gd
# Path: scripts/autoloads/AudioManager.gd
# Manages all audio (music and sound effects)
# ===========================================
extends Node

var master_volume: float = 1.0
var music_volume: float = 0.7
var sfx_volume: float = 0.8

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
var max_sfx_players: int = 16

var current_music_track: String = ""

func _ready():
	print("🎵 AudioManager initialized")
	setup_audio_players()

func setup_audio_players():
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Music"
	add_child(music_player)

	for i in range(max_sfx_players):
		var player = AudioStreamPlayer.new()
		player.name = "SFXPlayer" + str(i)
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)

## RECOMMENDED: Play music using preloaded AudioStream resource
## Use with AudioRegistry constants for compile-time validation
func play_music_resource(stream: AudioStream, loop: bool = true):
	if not stream:
		push_warning("AudioManager: Attempted to play null music stream")
		return

	music_player.stream = stream
	music_player.volume_db = linear_to_db(music_volume * master_volume)
	if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
		stream.loop = loop
	music_player.play()
	current_music_track = stream.resource_path
	print("🎵 Playing music: ", current_music_track)

## DEPRECATED: Use play_music_resource() with AudioRegistry constants instead
func play_music(track_path: String, loop: bool = true):
	push_warning("AudioManager.play_music() with string path is deprecated - use play_music_resource() with AudioRegistry constants")

	if not ResourceLoader.exists(track_path):
		print("❌ Music track not found: ", track_path)
		return

	var stream = load(track_path)
	if stream:
		music_player.stream = stream
		music_player.volume_db = linear_to_db(music_volume * master_volume)
		if stream is AudioStreamOggVorbis or stream is AudioStreamMP3:
			stream.loop = loop
		music_player.play()
		current_music_track = track_path
		print("🎵 Playing music: ", track_path)

func stop_music():
	music_player.stop()
	current_music_track = ""

## RECOMMENDED: Play SFX using preloaded AudioStream resource
## Use with AudioRegistry constants for compile-time validation
func play_sfx_resource(stream: AudioStream, volume_modifier: float = 1.0):
	if not stream:
		push_warning("AudioManager: Attempted to play null AudioStream")
		return

	var available_player = get_available_sfx_player()
	if not available_player:
		return

	available_player.stream = stream
	available_player.volume_db = linear_to_db(sfx_volume * master_volume * volume_modifier)
	available_player.play()

## DEPRECATED: Use play_sfx_resource() with AudioRegistry constants instead
## This method kept for backward compatibility only
func play_sfx(sfx_path: String, volume_modifier: float = 1.0):
	push_warning("AudioManager.play_sfx() with string path is deprecated - use play_sfx_resource() with AudioRegistry constants")

	if not ResourceLoader.exists(sfx_path):
		print("❌ SFX not found: ", sfx_path)
		return

	var available_player = get_available_sfx_player()
	if not available_player:
		return

	var stream = load(sfx_path)
	if stream:
		available_player.stream = stream
		available_player.volume_db = linear_to_db(sfx_volume * master_volume * volume_modifier)
		available_player.play()

func get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	return sfx_players[0]

func set_master_volume(volume: float):
	master_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

func update_volumes():
	if music_player:
		music_player.volume_db = linear_to_db(music_volume * master_volume)

func get_master_volume() -> float:
	return master_volume

func get_music_volume() -> float:
	return music_volume

func get_sfx_volume() -> float:
	return sfx_volume
