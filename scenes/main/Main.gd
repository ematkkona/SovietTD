# ===========================================
# 16. MAIN GAME SCENE SCRIPT
# Path: scenes/main/Main.gd
# ===========================================
extends Node2D

# Tower placement validation constants
const MIN_PATH_DISTANCE: float = 60.0  # Minimum distance from enemy path
const MIN_TOWER_DISTANCE: float = 40.0  # Minimum distance between towers
const PATH_SAMPLE_DISTANCE: float = 20.0  # Sample path every N pixels for validation
const LEVEL_BOUNDS: Rect2 = Rect2(50, 50, 1820, 980)  # Playable area

@onready var game_world = $GameWorld
@onready var level_container = $GameWorld/Level
@onready var camera = $GameWorld/Camera

var selected_tower_type: String = ""
var tower_placement_mode: bool = false
var placement_preview: Node2D = null  # TowerPlacementPreview instance

func _ready():
	print("🚩 Main game scene loaded!")
	
	setup_game_scene()
	load_current_level()
	
	EventBus.ui_tower_selected.connect(_on_ui_tower_selected)

func setup_game_scene():
	camera.enabled = true
	#camera.current = true
	camera.zoom = Vector2(0.8, 0.8)

	EventBus.enemy_spawned.connect(_on_enemy_spawned)

func load_current_level():
	create_test_level()

func create_test_level():
	var path = Path2D.new()
	path.name = "EnemyPath"

	# Attach path visualizer script
	var visualizer_script = load("res://scripts/utilities/PathVisualizer.gd")
	path.set_script(visualizer_script)

	var curve = Curve2D.new()

	# Create an interesting S-curve path with multiple turns
	# Start from left side, middle height
	curve.add_point(Vector2(100, 540))

	# Curve down to bottom
	curve.add_point(Vector2(400, 540), Vector2(0, 0), Vector2(100, 150))
	curve.add_point(Vector2(600, 850))

	# Sharp turn and curve up to top
	curve.add_point(Vector2(900, 850), Vector2(0, 0), Vector2(100, 0))
	curve.add_point(Vector2(1100, 250))

	# Gentle curve back to middle
	curve.add_point(Vector2(1400, 250), Vector2(0, 0), Vector2(80, 100))
	curve.add_point(Vector2(1650, 540))

	# Final stretch to exit
	curve.add_point(Vector2(1820, 540))

	path.curve = curve

	level_container.add_child(path)

	WaveManager.enemy_spawn_point = Vector2(100, 540)
	WaveManager.enemy_path = path

	print("✅ Test level created with complex S-curve path")

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if tower_placement_mode and placement_preview:
			var world_pos = get_global_mouse_position()

			if event.pressed:
				# Mouse/touch pressed down
				placement_preview.handle_tap(world_pos)
				# If preview is locked, check affordability before starting hold timer
				if placement_preview.get_locked_state():
					var tower_cost = TowerManager.get_tower_cost(selected_tower_type)
					if EconomyManager.can_afford(tower_cost):
						placement_preview.start_hold()
					else:
						# Flash the preview to indicate insufficient funds
						placement_preview.flash_invalid()
						print("❌ Cannot afford tower (need ", tower_cost, "₽, have ", EconomyManager.get_rubles(), "₽)")
			else:
				# Mouse/touch released
				placement_preview.stop_hold()

	# Update preview position on mouse move
	if event is InputEventMouseMotion:
		if tower_placement_mode and placement_preview:
			var world_pos = get_global_mouse_position()
			placement_preview.update_position(world_pos)
			# Check if dragged away while holding (cancel hold)
			placement_preview.check_hold_drag_distance(world_pos)

func _on_ui_tower_selected(tower_type: String):
	# Clean up any existing preview
	if placement_preview:
		placement_preview.queue_free()

	selected_tower_type = tower_type
	tower_placement_mode = true

	# Create placement preview
	var preview_script = load("res://scripts/UI/TowerPlacementPreview.gd")
	placement_preview = Node2D.new()
	placement_preview.set_script(preview_script)
	level_container.add_child(placement_preview)

	# Get tower range from the tower scene
	var tower_range = get_tower_range(tower_type)
	var tower_texture = get_tower_texture(tower_type)

	# Setup preview with validation callback
	placement_preview.setup(tower_texture, tower_range, is_valid_tower_position)

	# Connect signals
	placement_preview.placement_confirmed.connect(_on_placement_confirmed)
	placement_preview.placement_cancelled.connect(_on_placement_cancelled)

	print("🏗️ Tower placement preview created: ", tower_type)

func place_tower(tower_type: String, tower_pos: Vector2):
	var tower_scene_path = "res://scenes/towers/" + tower_type + ".tscn"

	if not ResourceLoader.exists(tower_scene_path):
		print("❌ Tower scene not found")
		return

	var tower_scene = load(tower_scene_path)
	var tower = tower_scene.instantiate()

	tower.global_position = tower_pos
	level_container.add_child(tower)

	print("🏗️ Placed ", tower_type, " at ", tower_pos)

func is_valid_tower_position(check_pos: Vector2) -> bool:
	# Check if within playable area
	if not LEVEL_BOUNDS.has_point(check_pos):
		print("⚠️ Position outside level bounds")
		return false

	# Check if too close to enemy path
	if WaveManager.enemy_path and WaveManager.enemy_path.curve:
		var path_length = WaveManager.enemy_path.curve.get_baked_length()
		var sample_count = int(path_length / PATH_SAMPLE_DISTANCE)

		for i in range(sample_count + 1):
			var offset = (float(i) / sample_count) * path_length
			var path_point = WaveManager.enemy_path.curve.sample_baked(offset)
			path_point += WaveManager.enemy_path.global_position

			if check_pos.distance_to(path_point) < MIN_PATH_DISTANCE:
				print("⚠️ Too close to enemy path")
				return false

	# Check if overlapping with existing towers
	for child in level_container.get_children():
		if child is BaseTower:
			if child.global_position.distance_to(check_pos) < MIN_TOWER_DISTANCE:
				print("⚠️ Too close to another tower")
				return false

	return true

func _on_enemy_spawned(enemy: Node2D):
	level_container.add_child(enemy)

func _on_placement_confirmed(tower_pos: Vector2):
	# Check affordability one final time
	var tower_cost = TowerManager.get_tower_cost(selected_tower_type)

	if not EconomyManager.can_afford(tower_cost):
		print("❌ Cannot afford tower (need ", tower_cost, "₽)")
		return

	if EconomyManager.spend_rubles(tower_cost):
		place_tower(selected_tower_type, tower_pos)

		# Clean up preview
		if placement_preview:
			placement_preview.queue_free()
			placement_preview = null

		# Reset placement mode
		tower_placement_mode = false
		selected_tower_type = ""
		print("✅ Tower placed successfully!")

func _on_placement_cancelled():
	tower_placement_mode = false
	selected_tower_type = ""
	placement_preview = null
	print("❌ Tower placement cancelled")

func get_tower_range(tower_type: String) -> float:
	# Load tower scene and extract range
	var tower_scene_path = "res://scenes/towers/" + tower_type + ".tscn"
	if ResourceLoader.exists(tower_scene_path):
		var tower_scene = load(tower_scene_path)
		var tower_temp = tower_scene.instantiate()

		# Call initialize_tower manually (normally called in _ready)
		if tower_temp.has_method("initialize_tower"):
			tower_temp.initialize_tower()

		var range_value = tower_temp.get("tower_range") if "tower_range" in tower_temp else 200.0
		# Use free() instead of queue_free() for immediate cleanup of temporary object
		tower_temp.free()
		return range_value
	return 200.0

func get_tower_texture(tower_type: String) -> Texture2D:
	# Try to get tower's sprite texture
	var tower_scene_path = "res://scenes/towers/" + tower_type + ".tscn"
	if ResourceLoader.exists(tower_scene_path):
		var tower_scene = load(tower_scene_path)
		var tower_temp = tower_scene.instantiate()

		# Look for Sprite2D child
		for child in tower_temp.get_children():
			if child is Sprite2D and child.texture:
				var texture = child.texture
				# Use free() instead of queue_free() for immediate cleanup of temporary object
				tower_temp.free()
				return texture

		# Use free() instead of queue_free() for immediate cleanup of temporary object
		tower_temp.free()

	# Fallback to placeholder
	return create_placeholder_texture(Color.GRAY, Vector2(32, 32))

func create_placeholder_texture(color: Color, size: Vector2) -> ImageTexture:
	var image = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
