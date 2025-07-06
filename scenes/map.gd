extends Control

@onready var net_manager = preload("res://net/scripts/net_manager.gd").new()
@onready var sync_manager = preload("res://net/scripts/sync_manager.gd").new()
var net_manager_instance: Node

var selected_agents: Array[Agent] = []

func _ready():
	add_child(net_manager)
	add_child(sync_manager)
	
	Global.load_agents() #do this after adding agents!
	Global.agent_died.connect(_on_agent_died)
	Global.send_agent.connect(send_agent.rpc)
	
	if not is_instance_valid(net_manager):
		push_error("Failed to initialize net manager!")
		return
	
	if not is_instance_valid(sync_manager):
		push_error("Failed to initialize sync manager!")
		return

func get_cursor_node():
	return $CanvasLayer

func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("clickMouse"):
		var selected_thing = get_thing_under_cursor(cursor_pos)
		if !selected_thing: return
		if selected_thing is Agent and !selected_thing.working:
			if not selected_agents.is_empty():
				selected_agents.pop_front().set_outline_visibility(false)
			selected_agents = []
			selected_agents.append(selected_thing)
			selected_thing.set_outline_visibility(true)
			#print("agent_selected")
		elif selected_thing is Room and selected_thing is not AnomalyChamber:
			#print("room_selected")
			if not selected_agents.is_empty():
				send_agent.rpc(selected_agents[0].entity_resource.agent_name, selected_thing.get_index())
				print("Trying to redirect an Agent")
		#elif !selected_thing.working:
			#selected_thing.show_work()

@rpc("any_peer", "call_local")
func send_agent(agent_name, room_index: int) -> String :
	var agent: Agent
	for node in get_tree().get_nodes_in_group("Agent"):
		if node.entity_resource.agent_name == agent_name:
			agent = node
	if !agent: print("agent_not_found"); return "agent_not_found"
	if agent.working: return "agent is working"
	print(multiplayer.get_unique_id(), agent.current_room)
	sync_manager._on_timer_timeout()
	while (agent.current_room == null): get_tree().get_frame()
	var path = FacilityNavigation.get_agent_path(agent.current_room, room_index)
	if path == []: return 'success stand'
	agent.path = path
	agent._on_travel()
	return "success move"
	
func _on_agent_died(agent: Agent):
	selected_agents.erase(agent)

func get_thing_under_cursor(cursor_pos):
	var containers = get_tree().get_nodes_in_group("Agent")
	var rooms = get_tree().get_nodes_in_group("Room")
	containers.append_array(rooms)
	var active_containers = containers.filter(func(thing): return thing.visible)
	for c in active_containers:
		#print(c.get_global_rect(), cursor_pos)
		if c.get_global_rect().has_point(cursor_pos):
			return c
	return null
