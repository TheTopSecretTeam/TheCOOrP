extends Node

var agents: Array[Agent] = []
var selected_agents: Array[Agent] = []

var armor: Array[ArmorStats] = [preload("res://res/scripts/agent/base_armor.tres").duplicate()]
var weapons: Array[WeaponStats] = [preload("res://res/scripts/agent/base_weapon.tres").duplicate()]

signal send_agent
signal agent_died(agent: Agent)

func _ready() -> void:
	Global.reset_globals.connect(reset)
	agent_died.connect(_on_agent_died)

func reset() -> void:
	agents.clear()
	selected_agents.clear()
	armor = [preload("res://res/scripts/agent/base_armor.tres").duplicate()]
	weapons = [preload("res://res/scripts/agent/base_weapon.tres").duplicate()]
	if agent_died.has_connections(): Helpers.disconnect_all(agent_died)
	agent_died.connect(_on_agent_died)
	if send_agent.has_connections(): Helpers.disconnect_all(send_agent)


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
