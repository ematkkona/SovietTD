# ===========================================
# AUTOLOAD: LevelManager.gd
# Path: scripts/managers/LevelManager.gd
# Manages level progression and level data
# ===========================================
extends Node

signal level_loaded(level_name: String)
signal level_started(level_name: String)
signal level_failed(level_name: String)

var current_level: String = ""
var current_level_index: int = 0
var levels_unlocked: int = 1

var level_data: Array[Dictionary] = [
	{
		"name": "Level01_Factory",
		"display_name": "Potato Factory Defense",
		"scene_path": "res://scenes/levels/Level01_Factory.tscn",
		"starting_rubles": 600,
		"starting_lives": 20
	},
	{
		"name": "Level02_RedSquare",
		"display_name": "Red Square Defense",
		"scene_path": "res://scenes/levels/Level02_RedSquare.tscn",
		"starting_rubles": 500,
		"starting_lives": 15
	},
	{
		"name": "TestLevel",
		"display_name": "Test Level",
		"scene_path": "res://scenes/levels/TestLevel.tscn",
		"starting_rubles": 1000,
		"starting_lives": 99
	}
]

func _ready():
	print("🗺️ LevelManager initialized")

func load_level(level_name: String) -> bool:
	var level_info = get_level_info(level_name)
	if level_info.is_empty():
		print("❌ Level not found: ", level_name)
		return false

	current_level = level_name
	level_loaded.emit(level_name)
	print("🗺️ Level loaded: ", level_info.display_name)
	return true

func start_level(level_name: String):
	if load_level(level_name):
		var level_info = get_level_info(level_name)

		EconomyManager.set_rubles(level_info.get("starting_rubles", 600))
		EconomyManager.set_lives(level_info.get("starting_lives", 20))

		level_started.emit(level_name)
		print("🚩 Level started: ", level_name)

func complete_level():
	if current_level != "":
		var next_index = get_level_index(current_level) + 1
		if next_index > levels_unlocked:
			levels_unlocked = next_index
			print("🔓 Unlocked next level!")

		EventBus.level_completed.emit()
		print("✅ Level completed: ", current_level)

func fail_level():
	level_failed.emit(current_level)
	print("💀 Level failed: ", current_level)

func get_level_info(level_name: String) -> Dictionary:
	for level in level_data:
		if level.name == level_name:
			return level
	return {}

func get_level_index(level_name: String) -> int:
	for i in range(level_data.size()):
		if level_data[i].name == level_name:
			return i
	return -1

func get_current_level() -> String:
	return current_level

func is_level_unlocked(level_index: int) -> bool:
	return level_index < levels_unlocked

func get_total_levels() -> int:
	return level_data.size()
