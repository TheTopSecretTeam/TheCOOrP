extends Control

## Aliases for localhost. When hostname matches, Connect acts as Host button.
const localhost_names: Array[String] = ["127.0.0.1", "localhost", "::1", ""]

func _ready() -> void:
	pass

func _on_host_button_down() -> void:
	if $name.text == "":
		$name.placeholder_text = "Field name must not be empty"
		$name.grab_focus() # Optional: put the cursor back in the field
		return
	SyncManager.HostLobby($name.text)

func _on_connect_button_down() -> void:
	if $name.text == "":
		$name.placeholder_text = "Field name must not be empty"
		$name.grab_focus() # Optional: put the cursor back in the field
		return
	SyncManager.ConnectToLobby($name.text, $hostname.text)

func _on_escape_button_down() -> void:
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
