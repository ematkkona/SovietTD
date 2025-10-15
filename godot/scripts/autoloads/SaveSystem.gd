# ===========================================
# AUTOLOAD: SaveSystem.gd
# Path: scripts/autoloads/SaveSystem.gd
# Handles saving and loading game progress
# ===========================================
extends Node

const SAVE_FILE = "user://savegame.save"

var save_data = {
	"player_progress": {
		"levels_unlocked": 1,
		"current_level": "",
		"high_scores": {}
	},
	"settings": {
		"master_volume": 1.0,
		"music_volume": 0.7,
		"sfx_volume": 0.8
	}
}

func _ready():
	print("💾 SaveSystem initialized")
	load_game_data()

func save_game_data():
	print("💾 Saving game data...")

	save_data.player_progress.levels_unlocked = LevelManager.levels_unlocked
	save_data.player_progress.current_level = LevelManager.get_current_level()

	save_data.settings.master_volume = AudioManager.get_master_volume()
	save_data.settings.music_volume = AudioManager.get_music_volume()
	save_data.settings.sfx_volume = AudioManager.get_sfx_volume()

	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data, "\t")
		file.store_string(json_string)
		file.close()
		print("✅ Game saved successfully")
	else:
		print("❌ Failed to save game data")

func load_game_data():
	print("💾 Loading game data...")

	if not FileAccess.file_exists(SAVE_FILE):
		print("ℹ️ No save file found, using defaults")
		return

	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		var json = JSON.new()
		var parse_result = json.parse(json_string)

		if parse_result == OK:
			var loaded_data = json.get_data()
			if typeof(loaded_data) == TYPE_DICTIONARY:
				save_data = loaded_data
				apply_loaded_data()
				print("✅ Game loaded successfully")
		else:
			print("❌ Failed to parse save file")
	else:
		print("❌ Failed to open save file")

func apply_loaded_data():
	if save_data.has("player_progress"):
		var progress = save_data.player_progress
		if progress.has("levels_unlocked"):
			LevelManager.levels_unlocked = progress.levels_unlocked

	if save_data.has("settings"):
		var settings = save_data.settings
		if settings.has("master_volume"):
			AudioManager.set_master_volume(settings.master_volume)
		if settings.has("music_volume"):
			AudioManager.set_music_volume(settings.music_volume)
		if settings.has("sfx_volume"):
			AudioManager.set_sfx_volume(settings.sfx_volume)

func delete_save_data():
	if FileAccess.file_exists(SAVE_FILE):
		DirAccess.remove_absolute(SAVE_FILE)
		print("🗑️ Save data deleted")
		save_data = {
			"player_progress": {
				"levels_unlocked": 1,
				"current_level": "",
				"high_scores": {}
			},
			"settings": {
				"master_volume": 1.0,
				"music_volume": 0.7,
				"sfx_volume": 0.8
			}
		}

func save_high_score(level_name: String, score: int):
	if not save_data.player_progress.high_scores.has(level_name) or \
	   score > save_data.player_progress.high_scores[level_name]:
		save_data.player_progress.high_scores[level_name] = score
		save_game_data()
		print("🏆 New high score for ", level_name, ": ", score)

func get_high_score(level_name: String) -> int:
	return save_data.player_progress.high_scores.get(level_name, 0)
