extends TextureProgressBar

@export var max_energy: int = 100

func _ready() -> void:
	max_value = max_energy
	value = 0

func set_energy(amount: int) -> void:
	value = clamp(amount, 0, max_value)

# animation
func animate_to(target: int, duration: float = 0.5) -> void:
	var clamped = clamp(target, 0, max_value)
	var tween = create_tween()
	tween.tween_property(self, "value", clamped, duration)
