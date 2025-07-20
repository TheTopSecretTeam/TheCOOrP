extends Control

@export var parent_path: NodePath = ^"../.."

func _on_return_button_pressed() -> void:
	# Close multiplayer connection
	get_node(parent_path).queue_free()
	SyncManager.leave_map()
	print("Disconnect: Switched to main_menu.tscn")
