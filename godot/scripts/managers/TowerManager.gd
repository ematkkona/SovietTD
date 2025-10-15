# ===========================================
# AUTOLOAD: TowerManager.gd
# Path: scripts/managers/TowerManager.gd
# Manages tower placement, upgrades, and removal
# ===========================================
extends Node

signal tower_placement_started(tower_type: String)
signal tower_placement_cancelled()

var tower_definitions: Dictionary = {
	"GuardTower": {
		"name": "Guard Tower",
		"cost": 100,
		"description": "Basic defensive tower"
	},
	"PropagandaSpeaker": {
		"name": "Propaganda Speaker",
		"cost": 150,
		"description": "Slows nearby enemies"
	},
	"BureaucraticOffice": {
		"name": "Bureaucratic Office",
		"cost": 200,
		"description": "Area damage tower"
	},
	"MissileStation": {
		"name": "Missile Station",
		"cost": 300,
		"description": "Heavy damage tower"
	}
}

var placed_towers: Array[Node2D] = []

func _ready():
	print("🏗️ TowerManager initialized")

func get_tower_cost(tower_type: String) -> int:
	if tower_definitions.has(tower_type):
		return tower_definitions[tower_type].cost
	return 100

func get_tower_info(tower_type: String) -> Dictionary:
	return tower_definitions.get(tower_type, {})

func register_tower(tower: Node2D):
	if tower and not placed_towers.has(tower):
		placed_towers.append(tower)
		EventBus.tower_placed.emit(tower, tower.global_position)
		print("🏗️ Tower registered: ", tower.name)

func unregister_tower(tower: Node2D):
	if tower and placed_towers.has(tower):
		placed_towers.erase(tower)
		print("🏗️ Tower unregistered: ", tower.name)

func sell_tower(tower: Node2D) -> int:
	if not tower or not placed_towers.has(tower):
		return 0

	var refund = 0
	if tower.has_method("get") and tower.get("tower_cost"):
		refund = int(tower.tower_cost * 0.7)

	unregister_tower(tower)
	EventBus.tower_sold.emit(tower, refund)
	tower.queue_free()

	return refund

func get_all_towers() -> Array[Node2D]:
	placed_towers = placed_towers.filter(func(t): return is_instance_valid(t))
	return placed_towers

func get_tower_count() -> int:
	return get_all_towers().size()
