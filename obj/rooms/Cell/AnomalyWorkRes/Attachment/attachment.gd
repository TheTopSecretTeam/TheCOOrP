extends Button

const PROB = 0.95

func _on_work_button_down() -> void: 
	var progress_bar = get_parent().get_parent().get_node("Sprite2D/Bar")
	progress_bar.work(PROB)
