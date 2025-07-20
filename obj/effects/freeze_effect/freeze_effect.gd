extends StatusEffect
class_name FreezeEffect

var base_walk_speed
# Called when the effect is first applied to a target
func on_apply() -> void:
	if !target: return
	base_walk_speed = target.entity_resource.travel_speed
	target.entity_resource.travel_speed *= 0.5
	target.modulate.g = 0.6
	target.modulate.r = 0.6

# Called when the effect expires (timer runs out)
func on_expire() -> void:
	if !target: return
	target.entity_resource.travel_speed = sign(target.entity_resource.travel_speed) * abs(base_walk_speed)
	target.modulate.g = 1
	target.modulate.r = 1

# Called if the effect is removed before expiration
func on_remove_early() -> void:
	if !target: return
	target.entity_resource.travel_speed = sign(target.entity_resource.travel_speed) * abs(base_walk_speed)
	target.modulate.g = 1
	target.modulate.r = 1

# Initialize the status effect with duration
func apply_status(duration: float, new_target: Entity) -> void:
	if is_instance_valid(new_target):
		for child in new_target.get_children():
			if is_instance_valid(child) and child is FreezeEffect:
				child.stop()
				child.start()
				return
	
	wait_time = duration
	one_shot = true
	self.stop()
	new_target.add_child.call_deferred(self)
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
