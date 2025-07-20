extends Control

@onready var finish_btn     : Button = $FinishButton
@onready var finish_menu    : MarginContainer  = $FinishMenu
@onready var restart_btn    : Button = $FinishMenu/VBoxContainer/RestartDayButton
@onready var next_day_btn   : Button = $FinishMenu/VBoxContainer/NextDayButton
func _ready():
	Global.quota_reached.connect(show)
	finish_btn.visible = true

	finish_btn.pressed.connect(_on_finish_pressed)
	restart_btn.pressed.connect(_on_restart_pressed)
	next_day_btn.pressed.connect(_on_next_day_pressed)

func _on_finish_pressed():
	finish_menu.visible = true

func _on_restart_pressed():
	pass

func _on_next_day_pressed():
	pass


func _on_restart_day_button_pressed() -> void:
	pass # Replace with function body.


func _on_next_day_button_pressed() -> void:
	pass # Replace with function body.
