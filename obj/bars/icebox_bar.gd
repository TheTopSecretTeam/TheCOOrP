extends AnomalyBar

var freeze_stage = 0

func _on_bar_work_completed(pe_box: Variant) -> void:
	work_completed.emit(pe_box)
	#print(anomaly_action.action_name)
	if anomaly_action.action_name == "Freeze":
		gain_freeze_stage()
	if anomaly_action.action_name == "Warm Up":
		clear_ice_auras()

func gain_freeze_stage():
	$FreezeTimer.start()
	if freeze_stage >= 3: return
	if freeze_stage > 0:
		var children = chamber.get_children().duplicate()
		for child in children:
			if is_instance_valid(child) and child is IceAura:
				child.scale += Vector2(freeze_stage * 7, freeze_stage * 7)
				freeze_stage+=1
	else:
		freeze_stage+=1
		var ice_aura = preload("res://obj/entities/anomaly_entities/ice_aura.tscn").instantiate()
		chamber.add_child(ice_aura)

func _on_freeze_timer_timeout() -> void:
	gain_freeze_stage()

func clear_ice_auras():
	if not is_instance_valid(chamber):
		return
	var children = chamber.get_children().duplicate()
	for child in children:
		if is_instance_valid(child) and child is IceAura:
			child.queue_free()
	freeze_stage = 0
	$FreezeTimer.start()
