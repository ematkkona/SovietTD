# ===========================================
# HealthSystem.gd
# Path: scripts/UI/utilities/HealthSystem.gd
# Reusable health management component
# ===========================================
extends Node

signal health_changed(current: int, maximum: int)
signal died()
signal damaged(amount: int)
signal healed(amount: int)

@export var max_health: int = 100
@export var starting_health: int = 100

var current_health: int = 100

func _ready():
	current_health = starting_health
	if starting_health > max_health:
		max_health = starting_health
	emit_health_changed()

func take_damage(amount: int) -> bool:
	if current_health <= 0:
		return false

	current_health -= amount
	current_health = max(current_health, 0)

	damaged.emit(amount)
	emit_health_changed()

	if current_health <= 0:
		die()
		return true

	return false

func heal(amount: int):
	if current_health >= max_health:
		return

	current_health += amount
	current_health = min(current_health, max_health)

	healed.emit(amount)
	emit_health_changed()

func die():
	died.emit()

func is_alive() -> bool:
	return current_health > 0

func get_health() -> int:
	return current_health

func get_max_health() -> int:
	return max_health

func get_health_percent() -> float:
	if max_health == 0:
		return 0.0
	return float(current_health) / float(max_health)

func set_health(value: int):
	current_health = clamp(value, 0, max_health)
	emit_health_changed()

func set_max_health(value: int):
	max_health = max(1, value)
	current_health = min(current_health, max_health)
	emit_health_changed()

func emit_health_changed():
	health_changed.emit(current_health, max_health)
