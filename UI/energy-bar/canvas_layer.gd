extends CanvasLayer

@export var step: int = 10
@export var anim_time: float = 0.3

@onready var energy_bar = $Control/TextureProgressBar
@onready var day_label  = $Control/DayLabel

func _ready() -> void:
	energy_bar.max_value = Global.energy_quota
	Global.energy_changed.connect(fill)


func fill(current_quota: int) -> void:
	energy_bar.animate_to(current_quota, anim_time)

func _on_fill_button_pressed() -> void:
	var target = energy_bar.value + step
	energy_bar.animate_to(target, anim_time)

# update the day counter
func update_day(day: int) -> void:
	if day_label:
		day_label.text = "Day %d" % day
