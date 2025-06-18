extends Control

var unique_pe = 0

func _ready() -> void:
	var anim_player = $Dude/Sprite2D/AnimationPlayer
	anim_player.play("Tenna Idle")
	
func begin_work(probability):
	var progress_bar = $Progress_Bar/Container/Bar
	progress_bar.work(probability)
	

func _on_progress_bar_work_completed(pe: Variant) -> void:
	unique_pe += pe
	var unique_pe_counter = $Unique_PE_Counter
	unique_pe_counter.text = str(unique_pe)


func _on_instinct_button_down() -> void:
	var probability = 0.5
	begin_work(probability)


func _on_insight_button_down() -> void:
	var probability = 0.70
	begin_work(probability)


func _on_attachment_button_down() -> void:
	var probability = 0.95
	begin_work(probability)


func _on_repression_button_down() -> void:
	var probability = 0.01
	begin_work(probability)
