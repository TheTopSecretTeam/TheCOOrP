extends Button

@onready var research_window = $ResearchWindow

func _on_button_down() -> void:
	research_window.show()


func _on_exit_button_down() -> void:
	research_window.hide()
