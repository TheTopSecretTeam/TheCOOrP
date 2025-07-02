extends Timer

@export var label : Node
var started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started:
		label.text = str(snappedf(time_left, 0.01))
