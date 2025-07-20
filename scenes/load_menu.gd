extends Control

var save1
var save2
var save3
var save4

func _ready() -> void:
	update_slots_information()

func save_to_file(content):
	var file = FileAccess.open("user://save_game.tscn", FileAccess.WRITE)
	file.store_string(content)

func load_from_file():
	var file = FileAccess.open("user://save_game.tscn", FileAccess.READ)
	var content = file.get_as_text()
	return content

func update_slots_information():
#	var file = FileAccess.open(player_file1, FileAccess.READ)
	for index in range(0,3):
		if FileAccess.file_exists("res://save" + str(index) + ".tscn"):
			$MarginContainer/VBoxContainer.get_child(int(index)).text = "SAVE STORED"
		else:
			$MarginContainer/VBoxContainer.get_child(int(index)).text = "EMPTY"


func _on_save_pressed(index) -> void:
	Global.save_file_path = "res://save%d.tscn" % index
	if FileAccess.file_exists("res://save" + str(index) + ".tscn"):
		Global.loading = true
	if Global.singleplayer:
		if Global.loading:
			get_tree().change_scene_to_file(Global.save_file_path)
		else:
			get_tree().change_scene_to_file("res://scenes/map.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/multiplayer.tscn")
	#$MarginContainer/VBoxContainer.get_child(index)


func _on_back_button_pressed() -> void:
	pass # Replace with function body.
