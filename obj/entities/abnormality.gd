# monster.gd
extends CharacterBody3D

@export var resource: AbnormalityResource
var behavior_instance: GDScript

func _ready():
	if resource and resource.behaviour:
		# Create and attach behavior
		behavior_instance = resource.behaviour.new()
		behavior_instance.abno = self

func _process(delta):
	if behavior_instance:
		behavior_instance._process(delta)
