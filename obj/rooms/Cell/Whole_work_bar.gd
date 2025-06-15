extends Node2D

signal work_completed(pe)

func _on_bar_work_completed(pe_box: Variant) -> void:
	work_completed.emit(pe_box)
