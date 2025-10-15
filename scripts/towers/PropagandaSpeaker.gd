# ===========================================
# 9. PROPAGANDA SPEAKER
# Path: scripts/towers/PropagandaSpeaker.gd
# ===========================================
extends BaseTower

var propaganda_timer: Timer
var slow_effect_strength: float = 0.5

func initialize_tower():
	print("⚙️ PropagandaSpeaker.initialize_tower() called")
	tower_name = "Propaganda Speaker"
	tower_cost = 150
	damage = 0
	urange = 180.0
	fire_rate = 0.5

func _ready():
	print("⚙️ PropagandaSpeaker._ready() called")
	super()  # Call parent _ready() first

	if sprite:
		sprite.texture = PixelArtHelper.create_propaganda_speaker_sprite()

	setup_propaganda_system()
	print("✅ PropagandaSpeaker fully initialized")

func setup_propaganda_system():
	propaganda_timer = Timer.new()
	propaganda_timer.wait_time = 2.0
	propaganda_timer.autostart = true
	add_child(propaganda_timer)
	propaganda_timer.timeout.connect(_broadcast_propaganda)

func _broadcast_propaganda():
	print("📢 PropagandaSpeaker broadcasting! Enemies in range: ", enemies_in_range.size())
	for enemy in enemies_in_range:
		if is_instance_valid(enemy) and enemy.has_method("apply_slow_effect"):
			enemy.apply_slow_effect(slow_effect_strength, 3.0)
			print("📢 Applied slow to enemy")

func create_projectile() -> Node2D:
	return null
