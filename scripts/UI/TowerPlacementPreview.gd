# ===========================================
# TowerPlacementPreview.gd
# Path: scripts/UI/TowerPlacementPreview.gd
# Handles tower ghost preview with range indicator
# ===========================================
extends Node2D

signal placement_confirmed(position: Vector2)
signal placement_cancelled()

# Visual configuration
@export var tower_range: float = 200.0
@export var valid_color: Color = Color(0.2, 0.8, 0.2, 0.3)  # Green
@export var invalid_color: Color = Color(0.8, 0.2, 0.2, 0.3)  # Red
@export var flash_speed: float = 3.0

# Range indicator configuration
const CIRCLE_SEGMENTS: int = 64
const FLASH_ALPHA_MIN: float = 0.2
const FLASH_ALPHA_MAX: float = 0.4
const VALID_OUTLINE_COLOR: Color = Color(0.2, 0.8, 0.2, 0.8)
const INVALID_OUTLINE_COLOR: Color = Color(0.8, 0.2, 0.2, 0.8)

# Placement configuration
const TAP_THRESHOLD: float = 50.0  # Distance to consider a second tap as confirmation
const LOCKED_OPACITY: float = 0.9
const UNLOCKED_OPACITY: float = 0.7
const LOCKED_OUTLINE_WIDTH: float = 4.0
const UNLOCKED_OUTLINE_WIDTH: float = 3.0

# Hold-to-confirm configuration
const HOLD_DURATION: float = 0.6  # Seconds to hold for confirmation
const PROGRESS_CIRCLE_RADIUS: float = 50.0  # Radius of progress circle
const PROGRESS_CIRCLE_WIDTH: float = 6.0
const PROGRESS_CIRCLE_SEGMENTS: int = 64
const PROGRESS_COLOR: Color = Color(1.0, 0.8, 0.0, 0.9)  # Gold/yellow
const PROGRESS_BG_COLOR: Color = Color(0.3, 0.3, 0.3, 0.5)  # Dark gray background
const PROGRESS_CIRCLE_OFFSET: Vector2 = Vector2(0, -120)  # Offset above tower to avoid finger

var tower_sprite: Sprite2D
var range_indicator: Polygon2D
var range_outline: Line2D
var is_valid_position: bool = false
var is_locked: bool = false  # First tap locks position
var locked_position: Vector2 = Vector2.ZERO
var validation_callback: Callable
var is_preview_shown: bool = false  # Track if preview has been shown yet

# Hold-to-confirm state
var is_holding: bool = false
var hold_progress: float = 0.0  # 0.0 to 1.0
var progress_circle: Line2D
var progress_circle_bg: Line2D
var glow_particles: Node2D  # Container for visual effects

func _ready():
	z_index = 100  # Draw on top of everything

	# Create tower ghost sprite
	tower_sprite = Sprite2D.new()
	tower_sprite.modulate = Color(1.0, 1.0, 1.0, 0.7)  # Semi-transparent
	add_child(tower_sprite)

	# Create range indicator (filled circle)
	range_indicator = Polygon2D.new()
	range_indicator.z_index = -1
	add_child(range_indicator)

	# Create range outline (circle edge)
	range_outline = Line2D.new()
	range_outline.width = UNLOCKED_OUTLINE_WIDTH
	range_outline.default_color = Color(1.0, 1.0, 1.0, 0.6)
	range_outline.z_index = 0
	add_child(range_outline)

	# Create progress circle background (full circle)
	progress_circle_bg = Line2D.new()
	progress_circle_bg.width = PROGRESS_CIRCLE_WIDTH
	progress_circle_bg.default_color = PROGRESS_BG_COLOR
	progress_circle_bg.z_index = 10
	progress_circle_bg.visible = false
	progress_circle_bg.position = PROGRESS_CIRCLE_OFFSET  # Position above tower
	add_child(progress_circle_bg)

	# Create progress circle (fills up during hold)
	progress_circle = Line2D.new()
	progress_circle.width = PROGRESS_CIRCLE_WIDTH
	progress_circle.default_color = PROGRESS_COLOR
	progress_circle.z_index = 11
	progress_circle.visible = false
	progress_circle.position = PROGRESS_CIRCLE_OFFSET  # Position above tower
	add_child(progress_circle)

	# Create glow effect container
	glow_particles = Node2D.new()
	glow_particles.z_index = 12
	glow_particles.position = PROGRESS_CIRCLE_OFFSET  # Position burst effects above tower too
	add_child(glow_particles)

	update_range_indicator()
	update_progress_circle_bg()

	# Hide preview initially - will show on first tap
	visible = false

func setup(tower_texture: Texture2D, tower_range_value: float, validation_func: Callable):
	tower_range = tower_range_value
	validation_callback = validation_func

	if tower_sprite and tower_texture:
		tower_sprite.texture = tower_texture

	update_range_indicator()

func _process(delta):
	# Flash red if invalid and unlocked (only when preview is shown)
	if is_preview_shown and not is_valid_position and not is_locked and not is_holding:
		var pulse = abs(sin(Time.get_ticks_msec() / 1000.0 * flash_speed))
		range_indicator.modulate.a = FLASH_ALPHA_MIN + pulse * (FLASH_ALPHA_MAX - FLASH_ALPHA_MIN)

	# Update hold progress
	if is_holding and is_valid_position:
		hold_progress += delta / HOLD_DURATION
		hold_progress = clamp(hold_progress, 0.0, 1.0)

		# Update progress circle visual
		update_progress_circle()

		# Pulse tower sprite while holding
		var pulse_scale = 1.0 + (sin(Time.get_ticks_msec() / 1000.0 * 8.0) * 0.1)
		tower_sprite.scale = Vector2(pulse_scale, pulse_scale)

		# Make range indicator pulse brighter
		var brightness = 1.0 + (sin(Time.get_ticks_msec() / 1000.0 * 6.0) * 0.3)
		range_indicator.modulate = Color(brightness, brightness, brightness, 1.0)

		# Check if hold is complete
		if hold_progress >= 1.0:
			complete_placement()
	elif not is_holding:
		# Reset visual effects when not holding
		tower_sprite.scale = Vector2.ONE
		if is_valid_position:
			range_indicator.modulate = Color(1.0, 1.0, 1.0, 1.0)

func update_position(new_pos: Vector2):
	# Don't update position until preview is shown
	if not is_preview_shown:
		return

	# Don't move while locked or holding
	if is_locked or is_holding:
		return

	global_position = new_pos
	check_validity()

func check_validity():
	if validation_callback.is_valid():
		is_valid_position = validation_callback.call(global_position)
	else:
		is_valid_position = true

	# Update colors
	var target_color = valid_color if is_valid_position else invalid_color
	range_indicator.color = target_color

	if is_valid_position:
		range_indicator.modulate.a = 1.0
		range_outline.default_color = VALID_OUTLINE_COLOR
	else:
		range_outline.default_color = INVALID_OUTLINE_COLOR

func start_hold():
	"""Called when user presses down (mouse/touch)"""
	if not is_preview_shown or not is_locked:
		return

	if not is_valid_position:
		flash_invalid()
		return

	is_holding = true
	hold_progress = 0.0
	progress_circle.visible = true
	progress_circle_bg.visible = true
	print("⏱️ Started holding to place tower")

func stop_hold():
	"""Called when user releases (mouse/touch)"""
	if not is_holding:
		return

	# If released before completion, cancel
	if hold_progress < 1.0:
		print("❌ Hold cancelled - released too early")
		is_holding = false
		hold_progress = 0.0
		progress_circle.visible = false
		progress_circle_bg.visible = false
		# Reset visual effects
		tower_sprite.scale = Vector2.ONE
		range_indicator.modulate = Color(1.0, 1.0, 1.0, 1.0)

func check_hold_drag_distance(current_pos: Vector2):
	"""Cancel hold if user drags away from locked position"""
	if not is_holding:
		return

	var distance = current_pos.distance_to(locked_position)
	if distance > TAP_THRESHOLD:
		print("❌ Hold cancelled - dragged away")
		stop_hold()

func complete_placement():
	"""Called when hold progress reaches 1.0"""
	if is_valid_position:
		# Create completion effect
		create_completion_burst()
		placement_confirmed.emit(global_position)
		print("✅ Tower placement confirmed!")

func create_completion_burst():
	"""Creates a satisfying visual burst when placement completes"""
	# Create expanding ring burst
	for i in range(3):
		var burst_ring = Line2D.new()
		burst_ring.width = 3.0
		burst_ring.default_color = PROGRESS_COLOR
		glow_particles.add_child(burst_ring)

		# Create circle points
		var points = PackedVector2Array()
		for j in range(PROGRESS_CIRCLE_SEGMENTS + 1):
			var angle = (float(j) / PROGRESS_CIRCLE_SEGMENTS) * TAU
			var point = Vector2(cos(angle), sin(angle)) * PROGRESS_CIRCLE_RADIUS
			points.append(point)
		burst_ring.points = points

		# Animate burst
		var tween = create_tween()
		tween.set_parallel(true)
		var start_scale = 1.0 + i * 0.3
		var end_scale = 2.5 + i * 0.5
		tween.tween_property(burst_ring, "scale", Vector2(end_scale, end_scale), 0.5).from(Vector2(start_scale, start_scale))
		tween.tween_property(burst_ring, "modulate:a", 0.0, 0.5).from(1.0)
		tween.finished.connect(burst_ring.queue_free)

	# Flash tower sprite bright
	var sprite_tween = create_tween()
	sprite_tween.tween_property(tower_sprite, "modulate", Color(2.0, 2.0, 2.0, 1.0), 0.1)
	sprite_tween.tween_property(tower_sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)

func update_progress_circle():
	"""Updates the progress circle to show current hold progress"""
	var points = PackedVector2Array()
	var num_segments = int(PROGRESS_CIRCLE_SEGMENTS * hold_progress)

	# Start from top (-90 degrees) and go clockwise
	for i in range(num_segments + 1):
		var angle = -PI / 2.0 + (float(i) / PROGRESS_CIRCLE_SEGMENTS) * TAU * hold_progress
		var point = Vector2(cos(angle), sin(angle)) * PROGRESS_CIRCLE_RADIUS
		points.append(point)

	progress_circle.points = points

func update_progress_circle_bg():
	"""Creates the background circle (full circle shown when holding)"""
	var points = PackedVector2Array()
	for i in range(PROGRESS_CIRCLE_SEGMENTS + 1):
		var angle = (float(i) / PROGRESS_CIRCLE_SEGMENTS) * TAU
		var point = Vector2(cos(angle), sin(angle)) * PROGRESS_CIRCLE_RADIUS
		points.append(point)

	progress_circle_bg.points = points

func handle_tap(tap_pos: Vector2):
	# If preview not shown yet, show it at tap position
	if not is_preview_shown:
		is_preview_shown = true
		visible = true
		global_position = tap_pos
		check_validity()
		print("🎯 Tower preview shown at tap position")
		return

	# If currently holding, ignore taps
	if is_holding:
		return

	# Placement flow: tap to show -> tap to lock -> hold to confirm
	if not is_locked:
		# First tap after showing - lock position
		is_locked = true
		locked_position = global_position
		tower_sprite.modulate = Color(1.0, 1.0, 1.0, LOCKED_OPACITY)
		range_outline.width = LOCKED_OUTLINE_WIDTH
		print("🎯 Tower position locked. Hold to confirm or tap elsewhere to move.")
	else:
		# Already locked - check if moving to new position
		var distance_from_locked = tap_pos.distance_to(locked_position)

		if distance_from_locked >= TAP_THRESHOLD:
			# Moving to new position
			unlock_position()
			global_position = tap_pos
			check_validity()
			print("🎯 Tower preview moved to new position")

func cancel_placement():
	placement_cancelled.emit()
	queue_free()

func unlock_position():
	is_locked = false
	tower_sprite.modulate = Color(1.0, 1.0, 1.0, UNLOCKED_OPACITY)
	range_outline.width = UNLOCKED_OUTLINE_WIDTH
	# Also hide progress circles when unlocking
	progress_circle.visible = false
	progress_circle_bg.visible = false
	hold_progress = 0.0
	is_holding = false

func get_locked_state() -> bool:
	return is_locked

func flash_invalid():
	# Create a quick red flash animation
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(range_indicator, "modulate:a", 0.7, 0.1)
	tween.tween_property(range_indicator, "modulate:a", 0.3, 0.1)
	tween.tween_property(range_indicator, "modulate:a", 0.7, 0.1)
	tween.tween_property(range_indicator, "modulate:a", 0.3, 0.1)

func update_range_indicator():
	if not range_indicator or not range_outline:
		return

	# Create circle points for both filled polygon and outline
	var points = PackedVector2Array()
	for i in range(CIRCLE_SEGMENTS + 1):
		var angle = (float(i) / CIRCLE_SEGMENTS) * TAU
		var point = Vector2(cos(angle), sin(angle)) * tower_range
		points.append(point)

	range_indicator.polygon = points
	range_outline.points = points
