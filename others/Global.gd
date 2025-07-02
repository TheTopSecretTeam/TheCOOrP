extends Node

var Players = {}
var color
var agents : Array[Node] = []

signal resources_changed(new_resources)

var resources : Dictionary[String, int] = {
	"Materials" : 12,
	"Funds" : 12, 
	"Radiance" : 12, 
	"Blight" : 12,
	}:
		set(value):
			resources = value
			resources_changed.emit(resources)
		get:
			return resources
			
var res1 = 12
var res2 = 12
var res3 = 12
var res4 = 12

var rng = RandomNumberGenerator.new()
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
