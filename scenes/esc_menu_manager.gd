extends Node


@onready var esc_menu = $"../CanvasLayer/EscapeMenu"
var game_paused: bool = false

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		game_paused = !game_paused

	if game_paused:
		get_tree().paused = true
		esc_menu.show()
	else:
		get_tree().paused = false
		esc_menu.hide()

func _on_resume_pressed():
	game_paused = !game_paused

func _on_quit_pressed():
	pass
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
