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

	# Only broadcast if there are enemies in range (efficient Soviet propaganda!)
	if enemies_in_range.is_empty():
		return

	# Create expanding halo visual effect
	create_propaganda_halo()

	for enemy in enemies_in_range:
		if is_instance_valid(enemy) and enemy.has_method("apply_slow_effect"):
			enemy.apply_slow_effect(slow_effect_strength, 3.0)
			print("📢 Applied slow to enemy")

func create_propaganda_halo():
	# Create a visual halo ring that expands outward
	var halo = Node2D.new()
	add_child(halo)

	# Create multiple concentric rings for effect
	for i in range(3):
		var ring = Node2D.new()
		halo.add_child(ring)

		# Draw the ring
		var ring_sprite = Sprite2D.new()
		ring_sprite.texture = create_ring_texture(20 + i * 10, Color(1, 1, 0, 0.6))  # Yellow rings
		ring.add_child(ring_sprite)

		# Animate: expand and fade out
		var tween = create_tween()
		tween.set_parallel(true)

		# Scale up from small to range size
		var start_scale = 0.3 + i * 0.2
		var end_scale = urange / 20.0  # Scale to match actual range
		tween.tween_property(ring, "scale", Vector2(end_scale, end_scale), 1.5).from(Vector2(start_scale, start_scale))

		# Fade out
		tween.tween_property(ring_sprite, "modulate:a", 0.0, 1.5).from(0.6 - i * 0.15)

		# Delay each ring slightly
		await get_tree().create_timer(0.15).timeout

	# Clean up after animation
	await get_tree().create_timer(1.5).timeout
	halo.queue_free()

func create_ring_texture(radius: int, color: Color) -> ImageTexture:
	var size = radius * 2 + 4
	var image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)

	var center = Vector2(size / 2.0, size / 2.0)
	var thickness = 2

	# Draw ring (circle outline)
	for angle in range(0, 360, 5):
		var rad = deg_to_rad(angle)
		var x = int(center.x + cos(rad) * radius)
		var y = int(center.y + sin(rad) * radius)

		# Draw thickness
		for dx in range(-thickness, thickness + 1):
			for dy in range(-thickness, thickness + 1):
				var px = x + dx
				var py = y + dy
				if px >= 0 and px < size and py >= 0 and py < size:
					image.set_pixel(px, py, color)

	return ImageTexture.create_from_image(image)

func create_projectile() -> Node2D:
	return null
