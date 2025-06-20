extends Control

var unique_pe = 0

func _ready() -> void:
	var anim_player = $Dude/Sprite2D/AnimationPlayer
	anim_player.play("Tenna Idle")


func _on_progress_bar_work_completed(pe: Variant) -> void:
	unique_pe += pe
	var unique_pe_counter = $Unique_PE_Counter
	unique_pe_counter.text = str(unique_pe)
