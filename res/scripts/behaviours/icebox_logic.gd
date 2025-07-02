extends AnomalyLogic

func start_work():
	pass

func work_tick():
	if RP + FP < MAX:
		generate_cell(PROB)
	else:
		work_completed.emit(RP)

func _on_bar_work_completed(pe_box: Variant) -> void:
	work_completed.emit(pe_box)

func generate_cell(prob: float) -> void:
	var success = [true, false]
	var weights = PackedFloat32Array([prob, 1-prob])
	if success[rng.rand_weighted(weights)]:
		RP += 1
	else:
		FP += 1

func work_end():
	Global.current_energy += RP
	match action.action_name:
		"Freeze":
			chamber.escape()
