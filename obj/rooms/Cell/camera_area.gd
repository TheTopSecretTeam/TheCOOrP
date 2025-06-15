extends Area2D

# Export a reference to the existing window node
@onready var existing_window = $WorkPopup

var working = false
var mouse_is_inside := false

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if (event is InputEventMouseButton and event.pressed and (not mouse_is_inside) and existing_window.visible):
		existing_window.hide()
		get_viewport().set_input_as_handled()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and (not working) and event.button_index == MOUSE_BUTTON_LEFT:
		if mouse_is_inside:
			existing_window.position = event.position
			existing_window.show()
		else:
			existing_window.hide()
			print("bruh")


func _on_instinct_button_down() -> void:
	working = true
	existing_window.hide()

func _on_insight_button_down() -> void:
	working = true
	existing_window.hide()

func _on_attachment_button_down() -> void:
	working = true
	existing_window.hide()

func _on_repression_button_down() -> void:
	working = true
	existing_window.hide()

func _on_progress_bar_work_completed(pe: Variant) -> void:
	working = false


func _on_mouse_entered() -> void:
	mouse_is_inside = true
	print("Y")

func _on_mouse_exited() -> void:
	mouse_is_inside = false
	print("N")
