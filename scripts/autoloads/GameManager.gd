# ===========================================
# 1. AUTOLOAD: GameManager.gd
# Path: scripts/autoloads/GameManager.gd
# ===========================================
extends Node

# Version information (single source of truth)
const VERSION_MAJOR: int = 0
const VERSION_MINOR: int = 21
const VERSION_STAGE: String = "Alpha"
const VERSION_STRING: String = "v0.21 (Alpha)"

signal game_started
@warning_ignore("unused_signal")
signal level_completed(level_name: String)
signal game_over

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER, VICTORY }
var current_state: GameState = GameState.MENU
var current_level: String = ""
var game_speed: float = 1.0

var total_score: int = 0

var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0

func _ready():
	print("🚩 GameManager initialized - For the glory of the motherland!")
	print("📦 Version: ", VERSION_STRING)
	process_mode = Node.PROCESS_MODE_ALWAYS

## Returns version in format "major.minor"
static func get_version_number() -> String:
	return "%d.%d" % [VERSION_MAJOR, VERSION_MINOR]

## Returns version in format "v0.2 (Alpha)"
static func get_version_full() -> String:
	return VERSION_STRING

func _input(event):
	if event.is_action_pressed("ui_cancel") and current_state == GameState.PLAYING:
		toggle_pause()

func start_game(level_name: String):
	current_level = level_name
	current_state = GameState.PLAYING
	game_speed = 1.0

	# Initialize economy through EconomyManager (single source of truth)
	EconomyManager.set_rubles(600)
	EconomyManager.set_lives(20)

	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")
	game_started.emit()
	print("🎮 Starting level: ", level_name)

func toggle_pause():
	var new_paused = current_state != GameState.PAUSED

	if new_paused:
		current_state = GameState.PAUSED
		get_tree().paused = true
	else:
		current_state = GameState.PLAYING
		get_tree().paused = false

	EventBus.game_paused.emit(new_paused)

func set_game_speed(speed: float):
	game_speed = clamp(speed, 0.5, 4.0)
	Engine.time_scale = game_speed
	print("⚡ Game speed: ", game_speed, "x")

func end_game(victory: bool):
	if victory:
		current_state = GameState.VICTORY
		print("🏆 Victory for the motherland!")
	else:
		current_state = GameState.GAME_OVER
		print("💀 The capitalists have won this time...")
	
	game_over.emit()
