extends Timer
class_name StatusEffect

var target
# Abstract base class for status effects
# Inherit from this to create specific status effects

# Called when the effect is first applied to a target
func on_apply() -> void:
	pass

# Called every frame while the effect is active
func on_process(delta: float) -> void:
	pass

# Called when the effect expires (timer runs out)
func on_expire() -> void:
	pass

# Called if the effect is removed before expiration
func on_remove_early() -> void:
	pass

# Initialize the status effect with duration
func apply_status(duration: float, new_target: Entity) -> void:
	wait_time = duration
	one_shot = true
	self.stop()
	new_target.add_child(self)
	target = new_target
	on_apply()

# Internal timeout handler
func _on_timeout() -> void:
	on_expire()
	queue_free()

# Remove the effect early (manually)
func remove_early() -> void:
	on_remove_early()
	queue_free()

# Override these if your effect needs custom processing
func _process(delta: float) -> void:
	if not is_stopped():
		on_process(delta)
