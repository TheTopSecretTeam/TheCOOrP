extends CanvasLayer

@export var step: int = 10
# animation
@export var anim_time: float = 0.3

@onready var energy_bar = $Control/TextureProgressBar

func _ready() -> void:
	energy_bar.max_value = Global.energy_quota
	Global.energy_changed.connect(fill)
	#fill_button.pressed.connect(_on_fill_button_pressed)

func fill(current_quota):
	energy_bar.animate_to(current_quota, anim_time)

func _on_fill_button_pressed() -> void:
	var target = energy_bar.value + step
	# filling animation
	energy_bar.animate_to(target, anim_time)
