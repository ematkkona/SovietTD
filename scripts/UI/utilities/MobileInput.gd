# ===========================================
# MobileInput.gd
# Path: scripts/UI/utilities/MobileInput.gd
# Mobile touch input handler
# ===========================================
extends Node

signal tower_placement_requested(tower_type: String, position: Vector2)
signal tower_selected(tower: Node2D)
signal camera_pan_requested(delta: Vector2)
signal camera_zoom_requested(zoom_level: float)

var is_dragging_camera: bool = false
var drag_start_position: Vector2 = Vector2.ZERO
var selected_tower_type: String = ""
var pinch_start_distance: float = 0.0

func _ready():
	print("📱 MobileInput initialized")

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch_input(event)
	elif event is InputEventScreenDrag:
		handle_drag_input(event)

func handle_touch_input(event: InputEventScreenTouch):
	if event.pressed:
		var world_pos = get_viewport().get_mouse_position()
		if selected_tower_type != "":
			tower_placement_requested.emit(selected_tower_type, world_pos)
			selected_tower_type = ""
		else:
			var clicked_tower = get_tower_at_position(world_pos)
			if clicked_tower:
				tower_selected.emit(clicked_tower)
			else:
				is_dragging_camera = true
				drag_start_position = event.position
	else:
		is_dragging_camera = false

func handle_drag_input(event: InputEventScreenDrag):
	if is_dragging_camera:
		var drag_delta = event.position - drag_start_position
		camera_pan_requested.emit(drag_delta)
		drag_start_position = event.position

func get_tower_at_position(pos: Vector2) -> Node2D:
	var space_state = get_viewport().world_2d.direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var result = space_state.intersect_point(query)

	for collision in result:
		var collider = collision.collider
		if collider.is_in_group("towers"):
			return collider

	return null

func set_selected_tower_type(tower_type: String):
	selected_tower_type = tower_type

func cancel_tower_placement():
	selected_tower_type = ""

func handle_pinch_zoom(distance: float):
	if pinch_start_distance == 0.0:
		pinch_start_distance = distance
	else:
		var zoom_factor = distance / pinch_start_distance
		camera_zoom_requested.emit(zoom_factor)
		pinch_start_distance = distance
