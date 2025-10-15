# ===========================================
# UpgradePanel.gd
# Path: scripts/UI/UpgradePanel.gd
# Tower upgrade and info panel
# ===========================================
extends Panel

signal upgrade_requested(tower: Node2D)
signal sell_requested(tower: Node2D)

@export var upgrade_button: Button
@export var sell_button: Button
@export var tower_info_label: Label
@export var upgrade_cost_label: Label

var selected_tower: Node2D = null

func _ready():
	hide()

	if upgrade_button:
		upgrade_button.pressed.connect(_on_upgrade_pressed)
	if sell_button:
		sell_button.pressed.connect(_on_sell_pressed)

func show_tower_info(tower: Node2D):
	if not tower:
		hide()
		return

	selected_tower = tower
	update_display()
	show()

func update_display():
	if not selected_tower:
		return

	if tower_info_label and selected_tower.has("tower_name"):
		var info_text = selected_tower.tower_name + "\n"
		info_text += "Level: " + str(selected_tower.tower_level) + "\n"
		info_text += "Damage: " + str(selected_tower.damage) + "\n"
		info_text += "Range: " + str(selected_tower.urange)
		tower_info_label.text = info_text

	if upgrade_cost_label:
		var upgrade_cost = get_upgrade_cost()
		upgrade_cost_label.text = "Upgrade: " + str(upgrade_cost) + "₽"

	if upgrade_button:
		var can_upgrade = can_upgrade_tower()
		upgrade_button.disabled = not can_upgrade

	if sell_button:
		var sell_value = get_sell_value()
		sell_button.text = "Sell (" + str(sell_value) + "₽)"

func can_upgrade_tower() -> bool:
	if not selected_tower:
		return false

	if selected_tower.tower_level >= selected_tower.max_level:
		return false

	var upgrade_cost = get_upgrade_cost()
	return EconomyManager.can_afford(upgrade_cost)

func get_upgrade_cost() -> int:
	if not selected_tower:
		return 0

	return 150 * selected_tower.tower_level

func get_sell_value() -> int:
	if not selected_tower or not selected_tower.has("tower_cost"):
		return 0

	return int(selected_tower.tower_cost * 0.7)

func _on_upgrade_pressed():
	if selected_tower and selected_tower.has_method("upgrade_tower"):
		if selected_tower.upgrade_tower():
			upgrade_requested.emit(selected_tower)
			update_display()

func _on_sell_pressed():
	if selected_tower:
		var refund = get_sell_value()
		EconomyManager.add_rubles(refund)
		sell_requested.emit(selected_tower)
		selected_tower.queue_free()
		selected_tower = null
		hide()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if not get_global_rect().has_point(event.position):
			hide()
			selected_tower = null
