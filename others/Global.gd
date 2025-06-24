extends Node

var Players = {}
var color
var agents : Array[Node] = []

var resources : Dictionary[String, int] = {"res1" : 12, "res2" : 12, "res3" : 12, "res4" : 12,}

var energy_quota : int = 10
var current_energy : int = 0:
	set(value):
		current_energy = value
		energy_changed.emit(current_energy)
		if energy_quota <= current_energy:
			quota_reached.emit()

signal energy_changed
signal quota_reached
signal send_agent

func load_agents():
	agents = get_tree().get_nodes_in_group("Agent")
