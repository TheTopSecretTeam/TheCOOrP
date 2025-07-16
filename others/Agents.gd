extends Node

var agents : Array[Agent] = []
var selected_agents: Array[Agent] = []

var armor : Array[ArmorStats] = [preload("res://res/scripts/agent/base_armor.tres").duplicate()]
var weapons : Array[WeaponStats] = [preload("res://res/scripts/agent/base_weapon.tres").duplicate()]

signal send_agent
signal agent_died(agent: Agent)

func _on_agent_died(agent: Agent):
	agents.erase(agent)

func _reset() -> void:
	for agent in Agents.agents:
			if is_instance_valid(agent):
				agent.queue_free()
	agents = []
	selected_agents = []


func load_agents():
	agents.assign(get_tree().get_nodes_in_group("Agent"))
	agent_died.connect(_on_agent_died)
