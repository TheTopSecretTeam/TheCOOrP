class_name IceAura
extends Node
var frozen_targets = {}
func _process(delta: float) -> void:
	self.rotation += 0.005
	var overlapping_areas = $Freeze_Area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.name == "CollisionBox":
			var target = area.get_parent()
			var freeze = preload("res://obj/effects/freeze_effect/freeze_effect.tscn").instantiate()
			freeze.apply_status(1, target)
			frozen_targets[target] = freeze
			print("Freeze Applied")

#func _on_freeze_area_area_entered(area: Area2D) -> void:
	#if area.name == "CollisionBox":
		#var target = area.get_parent()
		## Only apply if not already frozen
		#if not frozen_targets.has(target):
			#var freeze = preload("res://obj/effects/freeze_effect/freeze_effect.tscn").instantiate()
			#freeze.apply_status(30, target)
			#frozen_targets[target] = freeze
			#print("Freeze Applied")

#func _on_freeze_area_area_exited(area: Area2D) -> void:
	#pass
	#if area.name == "CollisionBox":
		#var target = area.get_parent()
#
		#if not is_instance_valid(target) or not frozen_targets.has(target):
			#return
#
		#var has_freeze_effect = false
		#for child in target.get_children():
			#if child is FreezeEffect:
				#has_freeze_effect = true
				#break
				#
		#if not has_freeze_effect:
			#frozen_targets.erase(target)
			#return
		#print("Freeze Erased")
		#var freeze = frozen_targets[target]
		#if is_instance_valid(freeze):
			#freeze.on_remove_early()
		#frozen_targets.erase(target)

#func _on_self_deleted():
	## Called when this freeze area is being deleted
	## Clean up all active freeze effects
	#for freeze in frozen_targets.values():
		#freeze.on_remove_early()
	#frozen_targets.clear()
