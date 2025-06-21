extends CanvasLayer

@export var step: int = 10
# animation
@export var anim_time: float = 0.3

@onready var energy_bar := $TextureProgressBar
@onready var fill_button := $FillButton

func _ready() -> void:
	fill_button.pressed.connect(_on_fill_button_pressed)

func _on_fill_button_pressed() -> void:
	var target = energy_bar.value + step
	# filling animation
	energy_bar.animate_to(target, anim_time)
