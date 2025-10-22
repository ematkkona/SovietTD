# ===========================================
# PathVisualizer.gd
# Path: scripts/utilities/PathVisualizer.gd
# Visualizes Path2D with a Line2D for enemy routes
# ===========================================
extends Path2D

# Visual configuration
@export var line_color: Color = Color(0.8, 0.2, 0.2, 0.4)  # Red with transparency
@export var line_width: float = 8.0
@export var show_arrows: bool = true
@export var arrow_spacing: float = 150.0  # Distance between arrows
@export var arrow_color: Color = Color(0.9, 0.3, 0.3, 0.6)

# Sampling configuration
const SAMPLE_DISTANCE: float = 10.0  # Sample path every N pixels
const ARROW_LOOKAHEAD_DISTANCE: float = 20.0  # Distance ahead to calculate arrow direction
const ARROW_SIZE: float = 15.0

var path_line: Line2D
var arrow_sprites: Array[Polygon2D] = []

func _ready():
	visualize_path()

func visualize_path():
	# Create the main path line
	path_line = Line2D.new()
	path_line.width = line_width
	path_line.default_color = line_color
	path_line.antialiased = true
	path_line.z_index = -1  # Draw behind everything else
	add_child(path_line)

	# Sample points along the curve
	if curve and curve.point_count > 0:
		var path_length = curve.get_baked_length()
		var sample_count = max(2, int(path_length / SAMPLE_DISTANCE))

		for i in range(sample_count + 1):
			var offset = (float(i) / sample_count) * path_length
			var point = curve.sample_baked(offset)
			path_line.add_point(point)

		# Add direction arrows if enabled
		if show_arrows:
			create_direction_arrows(path_length)

func create_direction_arrows(path_length: float):
	var arrow_count = max(1, int(path_length / arrow_spacing))

	for i in range(1, arrow_count + 1):
		var offset = (float(i) / (arrow_count + 1)) * path_length
		var point = curve.sample_baked(offset)

		# Get direction by sampling slightly ahead
		var ahead_offset = min(offset + ARROW_LOOKAHEAD_DISTANCE, path_length)
		var ahead_point = curve.sample_baked(ahead_offset)
		var direction = (ahead_point - point).normalized()

		# Create arrow polygon (triangle pointing in movement direction)
		var arrow = Polygon2D.new()
		arrow.color = arrow_color
		arrow.z_index = -1
		arrow.polygon = PackedVector2Array([
			Vector2(-ARROW_SIZE * 0.5, -ARROW_SIZE * 0.5),
			Vector2(ARROW_SIZE * 0.5, 0),
			Vector2(-ARROW_SIZE * 0.5, ARROW_SIZE * 0.5)
		])
		arrow.position = point
		arrow.rotation = direction.angle()

		add_child(arrow)
		arrow_sprites.append(arrow)

func update_visualization():
	# Clean up old visualization
	if path_line:
		path_line.queue_free()
	for arrow in arrow_sprites:
		arrow.queue_free()
	arrow_sprites.clear()

	# Recreate
	visualize_path()
