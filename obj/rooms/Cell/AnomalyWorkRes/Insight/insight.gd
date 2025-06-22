extends Button

const PROB = 0.70

func _on_work_button_down() -> void: 
	var progress_bar = get_parent().get_node("/root/ContainmentCell/CameraArea/Sprite2D/Bar")
	progress_bar.work(PROB)
