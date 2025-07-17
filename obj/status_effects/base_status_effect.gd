extends Timer
class_name StatusEffect

var target

# Abstract base class for status effects
# Inherit from this to create specific status effects

# Called when the effect is first applied to a target
func on_apply(target: Entity) -> void:
	pass

# Called every frame while the effect is active
func on_process(target: Entity, delta: float) -> void:
	pass

# Called when the effect expires (timer runs out)
func on_expire(target: Entity) -> void:
	pass

# Called if the effect is removed before expiration
func on_remove_early(target: Entity) -> void:
	pass

# Initialize the status effect with duration
func initialize(duration: float, target: Entity) -> void:
	wait_time = duration
	one_shot = true
	
	# If the effect is not stackable
	#if not target.is_a_parent_of(self):
		#target.add_child(self)
		#on_apply(target)
		#return
	
	# If the effect is stackable
	target.add_child(self)
	
	on_apply(target)

# Internal timeout handler
func _on_timeout(target: Entity) -> void:
	on_expire(target)
	queue_free()

# Remove the effect early
func remove_early(target: Entity) -> void:
	on_remove_early(target)
	queue_free()

# Override these if your effect needs custom processing
func _process(delta: float) -> void:
	if not is_stopped():
		on_process(get_parent(), delta)
