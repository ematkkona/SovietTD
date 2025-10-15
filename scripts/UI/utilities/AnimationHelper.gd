# ===========================================
# AnimationHelper.gd
# Path: scripts/UI/utilities/AnimationHelper.gd
# Helper functions for UI animations
# ===========================================
extends Node

func fade_in(node: CanvasItem, duration: float = 0.3):
	if not node:
		return

	var tween = create_tween()
	node.modulate.a = 0.0
	tween.tween_property(node, "modulate:a", 1.0, duration)

func fade_out(node: CanvasItem, duration: float = 0.3):
	if not node:
		return

	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)

func scale_bounce(node: Node2D, duration: float = 0.2):
	if not node:
		return

	var original_scale = node.scale
	var tween = create_tween()
	tween.tween_property(node, "scale", original_scale * 1.2, duration * 0.5)
	tween.tween_property(node, "scale", original_scale, duration * 0.5)

func shake(node: Node2D, intensity: float = 5.0, duration: float = 0.3):
	if not node:
		return

	var original_pos = node.position
	var tween = create_tween()
	var shake_count = 10

	for i in range(shake_count):
		var random_offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		tween.tween_property(node, "position", original_pos + random_offset, duration / shake_count)

	tween.tween_property(node, "position", original_pos, duration / shake_count)

func slide_in_from_left(node: Control, duration: float = 0.4):
	if not node:
		return

	var original_pos = node.position
	node.position.x -= 200
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "position", original_pos, duration)

func slide_in_from_right(node: Control, duration: float = 0.4):
	if not node:
		return

	var original_pos = node.position
	node.position.x += 200
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(node, "position", original_pos, duration)
