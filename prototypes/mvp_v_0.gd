extends Node2D

func _ready() -> void:
	var c = $corridor
	var a = $Agent
	c._add_agent(a)
