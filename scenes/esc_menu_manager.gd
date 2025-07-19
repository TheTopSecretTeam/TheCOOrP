extends Node


@onready var esc_menu = $"../CanvasLayer/EscapeMenu"
var game_paused: bool = false

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
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
	SyncManager.leave_map()
