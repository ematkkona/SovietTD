# ===========================================
# MainMenu.gd
# Path: scripts/UI/MainMenu.gd
# Main menu UI handler
# ===========================================
extends Control

@onready var play_button = $MenuContainer/PlayButton
@onready var settings_button = $MenuContainer/SettingsButton
@onready var quit_button = $MenuContainer/QuitButton
@onready var title_label = $MenuContainer/TitleLabel

func _ready():
	print("📋 Main Menu initialized")

	if play_button:
		play_button.pressed.connect(_on_play_pressed)
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

	if title_label:
		title_label.text = "Soviet Tower Defense"

func _on_play_pressed():
	print("🎮 Starting game...")
	GameManager.start_game("TestLevel")

func _on_settings_pressed():
	print("⚙️ Opening settings...")

func _on_quit_pressed():
	print("👋 Quitting game...")
	get_tree().quit()
