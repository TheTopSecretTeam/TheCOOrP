extends Button

const PROB = 0 # work success probability

func _on_button_down() -> void: 
	var progress_bar = get_parent().get_node("CameraArea/Sprite2D/Bar")
	progress_bar.work(PROB)
	
# extra functions, if any
