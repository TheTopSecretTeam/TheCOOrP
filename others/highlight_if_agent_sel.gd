extends Panel
func _process(delta: float) -> void:
	visible = not Agents.selected_agents.is_empty() and get_parent().get_global_rect().has_point(get_global_mouse_position())
