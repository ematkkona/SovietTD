# ===========================================
# BUREAUCRATIC OFFICE TOWER
# Path: scripts/towers/BureaucraticOffice.gd
# Area damage tower
# ===========================================
extends BaseTower

var area_damage_timer: Timer

func initialize_tower():
	print("⚙️ BureaucraticOffice.initialize_tower() called")
	tower_name = "Bureaucratic Office"
	tower_cost = 200
	damage = 15
	urange = 150.0
	fire_rate = 0.8

func _ready():
	print("⚙️ BureaucraticOffice._ready() called")
	super()  # Call parent _ready() first

	if sprite:
		sprite.texture = create_placeholder_texture(Color.BROWN, Vector2(32, 32))

	setup_area_damage()
	print("✅ BureaucraticOffice fully initialized")

func setup_area_damage():
	area_damage_timer = Timer.new()
	area_damage_timer.wait_time = 1.0 / fire_rate
	area_damage_timer.autostart = true
	add_child(area_damage_timer)
	area_damage_timer.timeout.connect(_deal_area_damage)

func _deal_area_damage():
	print("📋 BureaucraticOffice dealing damage! Enemies in range: ", enemies_in_range.size())
	if enemies_in_range.is_empty():
		return

	for enemy in enemies_in_range:
		if is_instance_valid(enemy) and enemy.has_method("take_damage"):
			enemy.take_damage(damage, self)
			print("📋 Dealt ", damage, " damage to enemy")

func create_projectile() -> Node2D:
	return null
