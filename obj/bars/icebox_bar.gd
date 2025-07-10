extends AnomalyBar

func _on_bar_work_completed(pe_box: Variant) -> void:
	work_completed.emit(pe_box)
	if anomaly_action.action_name == "Freeze":
		chamber.escape()
