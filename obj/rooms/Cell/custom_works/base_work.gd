class_name Work
extends Resource

@export var button_text : String
@export var icon : Texture2D
@export var scripts: Array[GDScript] = [] #For generic additional effects
@export var probabilty : float

var _ready_to_use : bool = true

#WARNING: DO NOT OVERWRITE
func execute(caller : Node) -> void:
	print("huh")
	if !_ready_to_use: return
	_run_behavior(caller)

#Override this in subclasses
func _run_behavior(_caller : Node) -> void:
	printerr("Behavior not implemented")
