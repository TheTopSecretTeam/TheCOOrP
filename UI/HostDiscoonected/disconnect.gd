extends CanvasLayer

func _ready() -> void:
	$Button.process_mode = Node.PROCESS_MODE_ALWAYS
	$Button.pressed.connect(_on_return_button_pressed)

func _on_return_button_pressed() -> void:
	# Close multiplayer connection
	if multiplayer.is_server():
		multiplayer.multiplayer_peer.close()
		print("Disconnect: Closed multiplayer peer on server")
	else:
		multiplayer.multiplayer_peer.close()
		print("Disconnect: Disconnected client, peer: ", multiplayer.get_unique_id())

	# Remove all other nodes in the scene tree
	var excluded_nodes = [Agents, Global, FacilityNavigation, Map]
	var current_scene = get_tree().current_scene  # Save current scene
	
	# Delete all scenes except this
	for child in get_tree().root.get_children():
		print(child.name)
		if child != current_scene and child not in excluded_nodes:  
			child.queue_free()

	for v in excluded_nodes:
		v._reset()
		
	# clear from cursors
	for child in Map.get_children():
		if child is Cursor:
			Map.remove_child(child)
			child.queue_free()

	# Unpause and switch to main menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	print("Disconnect: Switched to main_menu.tscn")
