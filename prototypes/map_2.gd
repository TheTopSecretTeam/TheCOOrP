extends Control

var selected_agents = []

#This implementation is meant to be changed

func _physics_process(_delta):
	var cursor_pos = get_global_mouse_position()
	if Input.is_action_just_pressed("clickMouse"):
		var selected_thing = get_thing_under_cursor(cursor_pos)
		if selected_thing is Agent:
			selected_agents = []
			selected_agents.append(selected_thing)
			#print("agent_selected")
		if selected_thing is Room:
			#print("room_selected")
			if selected_agents.size() != 0:
				send_agent(selected_agents[0], selected_thing.get_index())
				print("Trying to redirect an Agent")

func send_agent(agent, room_index: int):
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
