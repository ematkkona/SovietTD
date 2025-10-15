# ===========================================
# 3. AUTOLOAD: EconomyManager.gd
# Path: scripts/autoloads/EconomyManager.gd
# ===========================================
extends Node

signal rubles_changed(new_amount: int)
signal lives_changed(new_amount: int)
signal not_enough_rubles(required: int, current: int)

var rubles: int = 600
var lives: int = 20

const KILL_REWARD_BASE: int = 10

func _ready():
	print("💰 EconomyManager initialized")

func add_rubles(amount: int):
	rubles += amount
	print("💰 +", amount, " rubles (Total: ", rubles, ")")
	rubles_changed.emit(rubles)

func spend_rubles(amount: int) -> bool:
	if rubles >= amount:
		rubles -= amount
		print("💸 -", amount, " rubles (Total: ", rubles, ")")
		rubles_changed.emit(rubles)
		return true
	else:
		print("❌ Not enough rubles!")
		not_enough_rubles.emit(amount, rubles)
		return false

func can_afford(amount: int) -> bool:
	return rubles >= amount

func lose_life():
	lives -= 1
	print("💀 Life lost! Lives remaining: ", lives)
	lives_changed.emit(lives)
	
	if lives <= 0:
		print("☠️ All lives lost!")

func reward_kill(enemy_type: String):
	var reward = get_kill_reward(enemy_type)
	add_rubles(reward)

func get_kill_reward(enemy_type: String) -> int:
	var rewards = {
		"Businessman": 15,
		"Tourist": 12,
		"Spy": 25,
		"CEO": 100
	}
	return rewards.get(enemy_type, KILL_REWARD_BASE)

func get_rubles() -> int:
	return rubles

func get_lives() -> int:
	return lives

func set_rubles(amount: int):
	rubles = amount
	rubles_changed.emit(rubles)

func set_lives(amount: int):
	lives = amount
	lives_changed.emit(lives)
