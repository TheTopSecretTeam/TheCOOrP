extends Area2D

@onready var work_container = $WorkContainer
var wc_buttons : Array[Button]
@export var stats: Array[Resource] = [null, null, null, null]

var working = false
var mouse_is_inside := false

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))
	set_process_unhandled_input(true)
	work_container.hide()
	for i in stats.size():
		var work = Button.new()
		work_container.add_child(work)
		wc_buttons.append(work)
		wc_buttons[i].set_text(stats[i].button_text)
		wc_buttons[i].set_button_icon(stats[i].icon)
		wc_buttons[i].set_script(stats[i].scripts[0])
		wc_buttons[i].button_down.connect(wc_buttons[i]._on_work_button_down)
		wc_buttons[i].button_down.connect(_on_work_button_down)

func _unhandled_input(event):
	if (event is InputEventMouseButton and event.pressed and (not mouse_is_inside) and work_container.visible):
		work_container.hide()
		get_viewport().set_input_as_handled()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and (not working) and event.button_index == MOUSE_BUTTON_LEFT:
		work_container.position = event.position-self.position
		work_container.show()

func _on_work_button_down() -> void:
	working = true
	work_container.hide()

func _on_progress_bar_work_completed(_pe: Variant) -> void:
	working = false


func _on_mouse_entered() -> void:
	mouse_is_inside = true
	print("Y")

func _on_mouse_exited() -> void:
	mouse_is_inside = false
	print("N")
