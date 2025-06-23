extends Node

var Players = {}
var color
var agents : Array[Node] = []

var energy_quota : int = 10
var current_energy : int = 0:
	set(value):
		current_energy = value
		if energy_quota <= current_energy:
			quota_reached.emit()

signal quota_reached
signal send_agent

func load_agents():
	agents = get_tree().get_nodes_in_group("Agent")
