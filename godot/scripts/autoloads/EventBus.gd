# ===========================================
# EventBus.gd (Autoload: EventBus)
# Global event system for decoupled communication
# ===========================================
extends Node

# Tower events
signal tower_placed(tower: Node2D, position: Vector2)
signal tower_sold(tower: Node2D, refund: int)
signal tower_upgraded(tower: Node2D, new_level: int)

# Enemy events  
signal enemy_spawned(enemy: Node2D)
signal enemy_killed(enemy: Node2D, killer: Node2D)
signal enemy_reached_base(enemy: Node2D)

# Game events
signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)
signal level_completed()
signal game_paused(paused: bool)

# UI events
signal ui_tower_selected(tower_type: String)
signal ui_speed_changed(speed: float)
signal ui_special_ability_used(ability_name: String)

func _ready():
	print("📡 EventBus initialized - Comrade communication network ready!")
