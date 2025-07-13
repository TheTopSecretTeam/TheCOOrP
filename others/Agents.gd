extends Node

var agents : Array[Node] = []
var selected_agents: Array[Agent] = []

var armor : Array[ArmorStats] = [preload("res://res/scripts/agent/base_armor.tres").duplicate()]
var weapons : Array[WeaponStats] = [preload("res://res/scripts/agent/base_weapon.tres").duplicate()]

signal send_agent
signal agent_died(agent: Agent)

func _on_agent_died(agent: Agent):
	agents.erase(agent)

func load_agents():
	agents = get_tree().get_nodes_in_group("Agent")
	agent_died.connect(_on_agent_died)
