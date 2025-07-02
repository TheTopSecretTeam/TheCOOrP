extends Camera2D

@export var drag_sensitivity: float = 1.0
@export var zoom_sensitivity: float = 0.25
@export var min_zoom: float = 0.1
@export var max_zoom: float = 1.0

var _dragging := false
var _drag_start_position := Vector2.ZERO
var _camera_start_position := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE or event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				_dragging = true
				_drag_start_position = event.position
				_camera_start_position = position
			else:
				_dragging = false
		# Handle zooming with mouse wheel
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(1.0 + zoom_sensitivity)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(1.0 - zoom_sensitivity)
	
	if _dragging and event is InputEventMouseMotion:
		var drag_vector = (_drag_start_position - event.position) * drag_sensitivity / zoom.x
		position = _camera_start_position + drag_vector

func zoom_camera(factor: float) -> void:
	var new_zoom = zoom * factor
	new_zoom = new_zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	zoom = new_zoom
