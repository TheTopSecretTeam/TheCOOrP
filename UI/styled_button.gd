extends VBoxContainer

signal button_down

# Called when the node enters the scene tree for the first time.
func set_text(text) -> void:
	$Label.text = text

func set_button_icon(icon) -> void:
	$TextureButton.texture_normal = icon


func _on_texture_button_button_down() -> void:
	button_down.emit()
