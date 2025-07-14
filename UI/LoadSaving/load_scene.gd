extends Control


@onready var saving_system = preload("res://saving/saving.gd").new()
@onready var load_button = $CenterContainer/VBoxContainer/Load
@onready var option_button = $CenterContainer/VBoxContainer/SaveSelector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_button.pressed.connect(_on_load_pressed)
	populate_saves_optionbutton()

func populate_saves_optionbutton() -> void:
	option_button.clear()

	var saves = saving_system.get_all_saves()
	for save_path in saves:
		var file_name = save_path.get_file()
		var idx = option_button.get_item_count()
		option_button.add_item(file_name)
		option_button.set_item_metadata(idx, save_path)


func _on_load_pressed() -> void:
	var idx = option_button.get_selected()
	if idx == -1:
		print("No save selected!")
		return
	
	Global.filepath = option_button.get_item_metadata(idx)
	get_tree().change_scene_to_file("res://scenes/map.tscn")
	
