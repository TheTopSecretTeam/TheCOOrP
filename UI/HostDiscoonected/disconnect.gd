extends Control

func _on_return_button_pressed() -> void:
	# Close multiplayer connection
	SyncManager.leave_map()
	print("Disconnect: Switched to main_menu.tscn")
