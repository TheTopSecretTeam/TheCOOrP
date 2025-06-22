class_name AnomalyWork
extends Resource

@export var name: String
@export var icon: Texture2D
@export var work: Script

func _init(p_name = "Work", p_icon = "res://img/Cell/Instict_PH_DownScale.png", p_work =
 "res://obj/rooms/Cell/AnomalyWorkRes/Example/work_example.gd"):
	name = p_name
	icon = load(p_icon)
	work = load(p_work)
