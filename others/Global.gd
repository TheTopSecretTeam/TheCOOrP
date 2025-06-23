extends Node

var Players = {}
var color
var agents : Array[Node] = []

signal send_agent

func load_agents():
	agents = get_tree().get_nodes_in_group("Agent")
