extends TextureProgressBar

@export var max_energy: int = 10

@onready var label = $"../Label"

func _ready() -> void:
	max_value = max_energy
	value = 0
	_update_label()

func set_energy(amount: int) -> void:
	value = clamp(amount, 0, max_value)
	_update_label()
	
# animation
func animate_to(target: int, duration: float = 0.5) -> void:
	var clamped = clamp(target, 0, max_value)
	var tween = create_tween()
	tween.tween_property(self, "value", clamped, duration)
	tween.tween_callback(Callable(self, "_update_label"))

func _update_label() -> void:
	if label:
		label.text = str(value) + " / " + str(max_value)
