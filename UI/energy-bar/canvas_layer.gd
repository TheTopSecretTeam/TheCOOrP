extends CanvasLayer

@export var step: int = 10
@export var anim_time: float = 0.3

@onready var energy_bar = $Control/TextureProgressBar
@onready var day_label  = $Control/DayLabel

var current_day: int = 1

func _ready() -> void:
	#initialize the bar's maximum from the global quota and reset its current value
	energy_bar.max_value = Global.energy_quota
	energy_bar.set_energy(0)

	Global.energy_changed.connect(fill)

	#subscribe to day‑change if the signal exists in Global
	#if Global.has_signal("day_changed"):
		#Global.day_changed.connect(update_day)

	# Show the initial day
	update_day(current_day)


func fill(current_quota: int) -> void:
	energy_bar.animate_to(current_quota, anim_time)


func _on_fill_button_pressed() -> void:
	var target = energy_bar.value + step
	energy_bar.animate_to(target, anim_time)


func update_day(day: int) -> void:
	#called when the day changes
	#update the day label and reset the bar.
	current_day = day
	if day_label:
		day_label.text = "Day %d" % day

	# # Update max from global variable
	# energy_bar.max_value = Global.energy_quota
	# # Reset current energy value
	# energy_bar.set_energy(0)
	# # Emit energy reset so fill() animates bar back to zero
	# Global.energy_changed.emit(0)
