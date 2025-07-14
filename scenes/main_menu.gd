extends Control

@export var web_disable_list: Array[Button] = []

func _ready() -> void:
	#$ExitDialog.add_theme_icon_override("close", ImageTexture.new())
	# need when user press on exit or return to main menu, also for hist disconnected case
	Input.set_custom_mouse_cursor(null)
	if OS.get_name() == "Web":
		for btn in web_disable_list:
			btn.disabled = true

func _on_Multiplayer_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/multiplayer.tscn")

func _on_Singleplayer_pressed():
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _on_Settings_pressed():
	print("Settings are not implemented")

func _on_Exit_pressed():
	$ExitDialog.popup_centered()

func _on_Exit_confirmed():
	get_tree().quit()
