extends Node
## AudioRegistry autoload - DO NOT add class_name (conflicts with autoload)

## AudioRegistry - Centralized Audio Asset Management
##
## This autoload provides compile-time validated audio asset references.
## Use these constants instead of string paths to prevent runtime errors.
##
## Usage Example:
##   AudioManager.play_sfx_resource(AudioRegistry.SFX_TOWER_SHOOT)

# =============================================================================
# MUSIC TRACKS
# =============================================================================

# TODO: Replace with actual music files when available
# const MUSIC_MAIN_THEME = preload("res://assets/audio/music/main_theme.ogg")
# const MUSIC_MENU = preload("res://assets/audio/music/menu_music.ogg")
# const MUSIC_VICTORY = preload("res://assets/audio/music/victory_fanfare.ogg")

# =============================================================================
# COMBAT SFX
# =============================================================================

# NOTE: Godot must import WAV files first before preload will work
# After opening the project in Godot editor, uncomment these lines:

const SFX_TOWER_SHOOT = preload("res://assets/audio/sfx/combat/tower_shoot.wav")
# const SFX_MISSILE_LAUNCH = preload("res://assets/audio/sfx/combat/missile_launch.wav")  # TODO: Create this
const SFX_ENEMY_DEATH = preload("res://assets/audio/sfx/combat/enemy_death.wav")
const SFX_EXPLOSION = preload("res://assets/audio/sfx/combat/explosion.wav")

# =============================================================================
# TOWER SFX
# =============================================================================

const SFX_TOWER_PLACE = preload("res://assets/audio/sfx/towers/tower_place.wav")
# const SFX_TOWER_UPGRADE = preload("res://assets/audio/sfx/towers/tower_upgrade.wav")  # TODO: Create this
# const SFX_TOWER_SELL = preload("res://assets/audio/sfx/towers/tower_sell.wav")  # TODO: Create this

# =============================================================================
# UI SFX
# =============================================================================

const SFX_BUTTON_CLICK = preload("res://assets/audio/sfx/ui/button_click.wav")
const SFX_WAVE_START = preload("res://assets/audio/sfx/ui/wave_start.wav")
const SFX_WAVE_COMPLETE = preload("res://assets/audio/sfx/ui/wave_complete.wav")

# =============================================================================
# ECONOMY SFX
# =============================================================================

const SFX_COIN_COLLECT = preload("res://assets/audio/sfx/economy/coin_collect.wav")
const SFX_NOT_ENOUGH_FUNDS = preload("res://assets/audio/sfx/economy/not_enough_funds.wav")
# const SFX_LIFE_LOST = preload("res://assets/audio/sfx/economy/life_lost.wav")  # TODO: Create this

# =============================================================================
# VOICE LINES
# =============================================================================

# TODO: Replace with actual audio files when available
# const VOICE_WAVE_INCOMING = preload("res://assets/audio/voice/en/wave_incoming.ogg")
# const VOICE_TOWER_BUILT = preload("res://assets/audio/voice/en/tower_built.ogg")
# const VOICE_BASE_DAMAGED = preload("res://assets/audio/voice/en/base_damaged.ogg")

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

## Returns true if the given audio constant is available (not null)
static func is_audio_available(audio_stream: AudioStream) -> bool:
	return audio_stream != null

## Get a random variation from an array of audio streams
static func get_random_variation(variations: Array[AudioStream]) -> AudioStream:
	if variations.is_empty():
		push_warning("AudioRegistry: Attempted to get random variation from empty array")
		return null
	return variations[randi() % variations.size()]
