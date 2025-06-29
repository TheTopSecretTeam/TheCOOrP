extends Control

@onready var begin_btn      : Button        = $MarginContainer/VBoxContainer/BeginDayButton
@onready var day_label      : Label         = $MarginContainer/VBoxContainer/DayLabel
@onready var resources_label: Label         = $MarginContainer/VBoxContainer/ResourcesLabel
@onready var resources_box  : HBoxContainer = $MarginContainer/VBoxContainer/ResourcesBox
@onready var equipment_btn  : Button        = $MarginContainer/VBoxContainer/BottomButtons/EquipmentButton
@onready var hire_btn       : Button        = $MarginContainer/VBoxContainer/BottomButtons/HireButton

func _ready():
	begin_btn.pressed.connect(_on_begin_pressed)
	equipment_btn.pressed.connect(_on_equipment_pressed)
	hire_btn.pressed.connect(_on_hire_pressed)

func _on_begin_pressed():
	pass

func _on_equipment_pressed():
	pass

func _on_hire_pressed():
	pass
