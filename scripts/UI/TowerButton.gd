# ===========================================
# TowerButton.gd
# Path: scripts/UI/TowerButton.gd
# Custom button for tower selection
# ===========================================
extends Button

signal tower_button_clicked(tower_type: String)

@export var tower_type: String = ""
@export var tower_cost: int = 100
@export var tower_icon: Texture2D

var can_afford: bool = true

func _ready():
	pressed.connect(_on_pressed)
	update_button_state()

	if EconomyManager:
		EconomyManager.rubles_changed.connect(_on_rubles_changed)

func set_tower_data(type: String, cost: int, icon: Texture2D = null):
	tower_type = type
	tower_cost = cost
	tower_icon = icon
	update_button_display()

func update_button_display():
	if tower_icon:
		icon = tower_icon

	text = get_display_text()
	update_button_state()

func get_display_text() -> String:
	var tower_name = tower_type.replace("Tower", "").replace("Speaker", "")
	return tower_name + "\n" + str(tower_cost) + "₽"

func update_button_state():
	if EconomyManager:
		can_afford = EconomyManager.can_afford(tower_cost)
		disabled = not can_afford

		if not can_afford:
			modulate = Color(0.5, 0.5, 0.5, 1.0)
		else:
			modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_pressed():
	tower_button_clicked.emit(tower_type)
	EventBus.ui_tower_selected.emit(tower_type)

func _on_rubles_changed(_amount: int):
	update_button_state()
