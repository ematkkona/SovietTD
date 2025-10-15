# ===========================================
# MAIN MENU SCRIPT
# Path: scenes/main/MainMenu.gd
# ===========================================
extends Control

@onready var play_button = $MenuContainer/PlayButton
@onready var settings_button = $MenuContainer/SettingsButton
@onready var quit_button = $MenuContainer/QuitButton

func _ready():
	print("🚩 Main Menu loaded")

	if play_button:
		play_button.pressed.connect(_on_play_pressed)

	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)

	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	print("🎮 Starting game...")
	get_tree().change_scene_to_file("res://scenes/main/Main.tscn")

func _on_settings_pressed():
	print("⚙️ Settings not yet implemented")

func _on_quit_pressed():
	print("👋 Quitting...")
	get_tree().quit()
