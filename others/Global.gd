extends Node

var Players = {}
var color
var agents : Array[Node] = []

var armor : Array[ArmorStats] = [preload("res://res/scripts/agent/base_armor.tres").duplicate()]
var weapons : Array[WeaponStats] = [preload("res://res/scripts/agent/base_weapon.tres").duplicate()]

signal resources_changed(new_resources)

var resources : Dictionary[String, int] = {
	"Materials" : 12,
	"Funds" : 12, 
	"Radiance" : 12, 
	"Blight" : 12,
	}

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
signal agent_died(agent: Agent)

func _on_agent_died(agent: Agent):
	agents.erase(agent)

func load_agents():
	agents = get_tree().get_nodes_in_group("Agent")
	agent_died.connect(_on_agent_died)
