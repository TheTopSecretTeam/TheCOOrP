extends Control

@onready var net_manager = preload("res://net/scripts/net_manager.gd").new()
@onready var sync_manager = preload("res://net/scripts/sync_manager.gd").new()
@onready var tab_menu = preload("res://UI/tabMenu/TabMenu.tscn").instantiate()


var net_manager_instance: Node

var selected_agents: Array = []  # Явное указание типа

func _ready():
	add_child(net_manager)
	add_child(sync_manager)
	add_child(tab_menu)
	tab_menu.hide()
	
	Global.load_agents() #do this after adding agents!
	Global.send_agent.connect(send_agent.rpc)
	
	if not is_instance_valid(net_manager):
		push_error("Failed to initialize net manager!")
		return
	
	if not is_instance_valid(sync_manager):
		push_error("Failed to initialize sync manager!")
		return

func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("clickMouse"):
		var selected_thing = get_thing_under_cursor(cursor_pos)
		if !selected_thing: return
		if selected_thing is Agent:
			selected_agents = []
			selected_agents.append(selected_thing)
			#print("agent_selected")
		elif selected_thing is Room and selected_thing is not AnomalyChamber:
			#print("room_selected")
			if selected_agents.size() != 0:
				send_agent.rpc(selected_agents[0].agent_res.agent_name, selected_thing.get_index())
				print("Trying to redirect an Agent")
		#elif !selected_thing.working:
			#selected_thing.show_work()

@rpc("any_peer", "call_local")
func send_agent(agent_name, room_index: int):
	var agent: Agent
	for node in get_tree().get_nodes_in_group("Agent"):
		if node.agent_res.agent_name == agent_name:
			agent = node
	if !agent: print("agent_not_found"); return
	print(multiplayer.get_unique_id(), agent.current_room)
	sync_manager._on_timer_timeout()
	while (agent.current_room == null): await get_tree().get_frame()
	var path = $facility_navigation.get_agent_path(agent.current_room, room_index)
	agent.path = path
	agent._on_travel()

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
