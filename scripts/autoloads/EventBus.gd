# ===========================================
# EventBus.gd (Autoload: EventBus)
# Global event system for decoupled communication
# ===========================================
extends Node

# Tower events (emitted by TowerManager - warnings are false positives for event bus pattern)
signal tower_placed(tower: Node2D, position: Vector2)  ## Emitted by TowerManager when tower is placed
signal tower_sold(tower: Node2D, refund: int)  ## Emitted by TowerManager when tower is sold
signal tower_upgraded(tower: Node2D, new_level: int)  ## Reserved for tower upgrade system

# Enemy events (reserved for future features)
signal enemy_spawned(enemy: Node2D)  ## Reserved for spawn tracking
signal enemy_killed(enemy: Node2D, killer: Node2D)  ## Reserved for kill statistics
signal enemy_reached_base(enemy: Node2D)  ## Reserved for base breach events

# Game events (emitted by various managers)
signal wave_started(wave_number: int)  ## Reserved for wave state UI
signal wave_completed(wave_number: int)  ## Emitted by WaveManager
signal level_completed()  ## Emitted by LevelManager
signal game_paused(paused: bool)  ## Emitted by GameManager

# UI events (emitted by UI components)
signal ui_tower_selected(tower_type: String)  ## Emitted by TowerButton
signal ui_speed_changed(speed: float)  ## Reserved for game speed controls
signal ui_special_ability_used(ability_name: String)  ## Reserved for special abilities

func _ready():
	print("📡 EventBus initialized - Comrade communication network ready!")
