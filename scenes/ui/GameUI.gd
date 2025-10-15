# ===========================================
# 17. GAME UI SCRIPT
# Path: scenes/ui/GameUI.gd
# ===========================================
extends Control

@onready var rubles_label = $MarginContainer/VBoxContainer/TopBar/ResourcesPanel/RublesLabel
@onready var lives_label = $MarginContainer/VBoxContainer/TopBar/ResourcesPanel/LivesLabel
@onready var wave_label = $MarginContainer/VBoxContainer/TopBar/WaveInfo/WaveLabel
@onready var start_wave_btn = $MarginContainer/VBoxContainer/BottomBar/StartWaveBtn
@onready var tower_buttons_container = $MarginContainer/VBoxContainer/MiddleSection/SidePanel/TowerButtons

# Reference to existing tower buttons in scene
@onready var guard_tower_btn = $MarginContainer/VBoxContainer/MiddleSection/SidePanel/TowerButtons/GuardTowerBtn
@onready var propaganda_btn = $MarginContainer/VBoxContainer/MiddleSection/SidePanel/TowerButtons/PropagandaBtn
@onready var bureaucracy_btn = $MarginContainer/VBoxContainer/MiddleSection/SidePanel/TowerButtons/BureaucracyBtn
@onready var missile_btn = $MarginContainer/VBoxContainer/MiddleSection/SidePanel/TowerButtons/MissileBtn

@onready var speed_1x = $MarginContainer/VBoxContainer/BottomBar/Speed1x
@onready var speed_2x = $MarginContainer/VBoxContainer/BottomBar/Speed2x
@onready var speed_4x = $MarginContainer/VBoxContainer/BottomBar/Speed4x

func _ready():
	print("🎮 Game UI initialized")
	
	setup_ui()
	connect_signals()
	update_ui_values()

func setup_ui():
	connect_tower_buttons()
	connect_speed_buttons()

	if start_wave_btn:
		start_wave_btn.pressed.connect(_on_start_wave_pressed)

func connect_tower_buttons():
	if guard_tower_btn:
		guard_tower_btn.pressed.connect(_on_tower_button_pressed.bind("GuardTower"))
	if propaganda_btn:
		propaganda_btn.pressed.connect(_on_tower_button_pressed.bind("PropagandaSpeaker"))
	if bureaucracy_btn:
		bureaucracy_btn.pressed.connect(_on_tower_button_pressed.bind("BureaucraticOffice"))
	if missile_btn:
		missile_btn.pressed.connect(_on_tower_button_pressed.bind("MissileStation"))

func connect_speed_buttons():
	if speed_1x:
		speed_1x.pressed.connect(_on_speed_changed.bind(1.0))
	if speed_2x:
		speed_2x.pressed.connect(_on_speed_changed.bind(2.0))
	if speed_4x:
		speed_4x.pressed.connect(_on_speed_changed.bind(4.0))

func connect_signals():
	EconomyManager.rubles_changed.connect(_on_rubles_changed)
	EconomyManager.lives_changed.connect(_on_lives_changed)
	WaveManager.wave_started.connect(_on_wave_started)
	EventBus.wave_completed.connect(_on_wave_completed)

func update_ui_values():
	_on_rubles_changed(EconomyManager.get_rubles())
	_on_lives_changed(EconomyManager.get_lives())
	update_wave_info()

func update_wave_info():
	if not wave_label:
		return
		
	var current = WaveManager.get_current_wave()
	var total = WaveManager.get_total_waves()
	wave_label.text = "Wave " + str(current) + "/" + str(total)
	
	if start_wave_btn:
		start_wave_btn.disabled = WaveManager.is_wave_active()

func _on_rubles_changed(new_amount: int):
	if rubles_label:
		rubles_label.text = str(new_amount) + "₽"

func _on_lives_changed(new_amount: int):
	if lives_label:
		lives_label.text = str(new_amount) + "♥"

func _on_wave_started(wave_number: int):
	update_wave_info()
	print("📊 UI: Wave ", wave_number, " started")

func _on_wave_completed(wave_number: int):
	update_wave_info()
	print("📊 UI: Wave ", wave_number, " completed, button re-enabled")

func _on_tower_button_pressed(tower_type: String):
	EventBus.ui_tower_selected.emit(tower_type)
	print("🎯 Selected tower type: ", tower_type)

func _on_start_wave_pressed():
	WaveManager.start_next_wave()

func _on_speed_changed(speed: float):
	GameManager.set_game_speed(speed)
	print("⚡ Speed changed to ", speed, "x")
