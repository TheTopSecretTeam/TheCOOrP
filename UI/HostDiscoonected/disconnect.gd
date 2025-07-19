extends CanvasLayer

func _on_return_button_pressed() -> void:
	# Close multiplayer connection
	get_tree().current_scene.leave()
	print("Disconnect: Switched to main_menu.tscn")
