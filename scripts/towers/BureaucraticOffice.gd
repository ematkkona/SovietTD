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
		sprite.texture = PixelArtHelper.create_bureaucratic_office_sprite()

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
			# Launch paperwork at enemy
			launch_paperwork(enemy)
			enemy.take_damage(damage, self)
			print("📋 Dealt ", damage, " damage to enemy")

func launch_paperwork(target_enemy: Node2D):
	# Create flying paperwork particle
	var paper = Node2D.new()
	get_parent().add_child(paper)  # Add to scene root so it can move independently
	paper.global_position = global_position

	# Create paper sprite (small white rectangle)
	var paper_sprite = Sprite2D.new()
	paper_sprite.texture = create_paper_texture()
	paper.add_child(paper_sprite)

	# Random rotation for variety
	paper.rotation = randf() * TAU

	# Animate towards enemy
	var duration = 0.4
	var tween = create_tween()
	tween.set_parallel(true)

	# Move to enemy
	if is_instance_valid(target_enemy):
		tween.tween_property(paper, "global_position", target_enemy.global_position, duration)

	# Spin while flying
	tween.tween_property(paper, "rotation", paper.rotation + randf_range(2, 4) * TAU, duration)

	# Fade out on arrival
	tween.tween_property(paper_sprite, "modulate:a", 0.0, duration * 0.5).set_delay(duration * 0.5)

	# Clean up
	await tween.finished
	paper.queue_free()

func create_paper_texture() -> ImageTexture:
	var size = 12
	var image = Image.create(size, int(size * 1.4), false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)

	# White paper with slight variations
	var paper_color = Color(1, 1, 1, 0.9)
	for x in range(2, size - 2):
		for y in range(2, int(size * 1.4) - 2):
			image.set_pixel(x, y, paper_color)

	# Add some "text" lines
	var text_color = Color(0.2, 0.2, 0.2, 0.6)
	for line in range(3):
		var y = 4 + line * 4
		for x in range(3, size - 3):
			if y < int(size * 1.4) - 3:
				image.set_pixel(x, y, text_color)

	return ImageTexture.create_from_image(image)

func create_projectile() -> Node2D:
	return null
