extends CanvasLayer

func _ready() -> void:
	$Button.process_mode = Node.PROCESS_MODE_ALWAYS
	$Button.pressed.connect(_on_return_button_pressed)

func _on_return_button_pressed() -> void:
	print("Return button pressed!")

	var current_scene = get_tree().current_scene  # Save current scene
	
	var excluded_nodes = [Agents, Global, FacilityNavigation, Map]

	# Delete all scenes except this
	for child in get_tree().root.get_children():
		if child != current_scene and child not in excluded_nodes:  
			child.queue_free()

	get_tree().paused = false
	Global._reset()
	# Upload main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
