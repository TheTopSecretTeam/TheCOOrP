extends Panel
func _process(delta: float) -> void:
	visible = get_parent().get_global_rect().has_point(get_global_mouse_position())
