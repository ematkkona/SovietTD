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

var tower_sprite: Sprite2D
var range_indicator: Polygon2D
var range_outline: Line2D
var is_valid_position: bool = false
var is_locked: bool = false  # First tap locks position
var locked_position: Vector2 = Vector2.ZERO
var validation_callback: Callable

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

	update_range_indicator()

func setup(tower_texture: Texture2D, tower_range_value: float, validation_func: Callable):
	tower_range = tower_range_value
	validation_callback = validation_func

	if tower_sprite and tower_texture:
		tower_sprite.texture = tower_texture

	update_range_indicator()

func _process(_delta):
	# Flash red if invalid and unlocked
	if not is_valid_position and not is_locked:
		var pulse = abs(sin(Time.get_ticks_msec() / 1000.0 * flash_speed))
		range_indicator.modulate.a = FLASH_ALPHA_MIN + pulse * (FLASH_ALPHA_MAX - FLASH_ALPHA_MIN)

func update_position(new_pos: Vector2):
	if is_locked:
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

func handle_tap(tap_pos: Vector2):
	if not is_locked:
		# First tap - lock position
		is_locked = true
		locked_position = global_position
		tower_sprite.modulate = Color(1.0, 1.0, 1.0, LOCKED_OPACITY)
		range_outline.width = LOCKED_OUTLINE_WIDTH
		print("🎯 Tower position locked. Tap again to confirm or tap elsewhere to move.")
	else:
		# Second tap - check if confirming or moving
		var distance_from_locked = tap_pos.distance_to(locked_position)

		if distance_from_locked < TAP_THRESHOLD:
			# Confirming placement
			if is_valid_position:
				confirm_placement()
			else:
				print("❌ Cannot place tower at invalid position")
				flash_invalid()
		else:
			# Moving to new position
			unlock_position()
			global_position = tap_pos
			check_validity()
			print("🎯 Tower preview moved to new position")

func confirm_placement():
	if is_valid_position:
		placement_confirmed.emit(global_position)

func cancel_placement():
	placement_cancelled.emit()
	queue_free()

func unlock_position():
	is_locked = false
	tower_sprite.modulate = Color(1.0, 1.0, 1.0, UNLOCKED_OPACITY)
	range_outline.width = UNLOCKED_OUTLINE_WIDTH

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
