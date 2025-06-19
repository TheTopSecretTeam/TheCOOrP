extends Node2D
class_name Map

var rooms: Dictionary = {}     # room_id → Room instance
var astar := AStar2D.new()

var AgentScene: PackedScene = preload("res://obj/entities/agent.tscn")

# array of agents
var agents: Array = []
# agent that currently is selected
var selected_agent: Agent

func _ready() -> void:
	_find_rooms()
	#_link_rooms()   # your manual neighbor setup
	_build_astar()
	
	_initialize_agents()
	
	
func _initialize_agents() -> void:
	var spawn_plan = {
		1: ["alice"],
		2: ["charlie"],
		4: ["dora"]
	}
	
	for room_id in spawn_plan:
		if not rooms.has(room_id):
			push_warning("No room %d to spawn agents into" % room_id)
			continue
			
		var room = rooms[room_id]
		var names = spawn_plan[room_id]
		
		for name in names:
			# 1) Instance a new Agent
			var agent_instance = AgentScene.instantiate() as Agent
			# 2) Give it a unique name or ID
			agent_instance.agent_name = name
			 # 3) Tell the room to adopt it
			room._add_agent(agent_instance)
			# we assign the agent a room in which he is located
			agent_instance.current_room = room_id
			# (Optionally randomize its offset a bit)
			agent_instance.position += room.global_position + Vector2(randf_range(-16,16), randf_range(-16,16))
			agents.append(agent_instance)
		
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# if you already select agent
		# 1) Find which room was clicked on (if any)

		if selected_agent:
			var previous_selected_agent = selected_agent
			_click_agent(event.global_position)
			print(selected_agent.agent_name)
			if (selected_agent == null or previous_selected_agent != selected_agent): return
			
			var selected_room = _determine_room(event.global_position)
			if selected_room == null: return
			print(selected_room)
			var to_id = _room_id(selected_room);
			var from_id = selected_agent.current_room;
			
			if astar.has_point(from_id) and astar.has_point(to_id):
				var point_path: Array = astar.get_point_path(from_id, to_id)
				var id_path: Array = astar.get_id_path(from_id, to_id)
				print("Path by IDs: ", id_path)
				selected_agent.load_path(id_path)
				selected_agent._on_travel()
			else:
				push_warning("Invalid start/end in A* graph")
		else:	
			_click_agent(event.global_position)
			if selected_agent: print(selected_agent.agent_name)
		
func _click_agent(click_pos) -> void:
	for agent in agents:
		var dist = agent.global_position.distance_to(click_pos)
		var agent_radius = 10.0
		
		if dist <= agent_radius:
			# it means you clicked on the agent
			# if click on already selected agent it will cancell you previous selection
			if selected_agent == agent:
				selected_agent = null
			else:
				selected_agent = agent
			break
		
					
func _determine_room(pos: Vector2) -> Room:
	for room in rooms.values():
		var size: Vector2 = room._size()
		var top_left: Vector2 = room.global_position
		var rect: Rect2 = Rect2(top_left, size)
		if rect.has_point(pos):
			return room
			
	return null
		
func _find_rooms() -> void:
	# Assume your rooms are direct children named "Room1", "Room2", …
	for room_node in get_children():
		if room_node is Room:
			rooms[_room_id(room_node)] = room_node


func _room_id(room:Room) -> int:
	return room.get_index()

func _build_astar() -> void:
	# 1) Add each room as a point in the AStar graph
	for id in rooms.keys():
		var room = rooms[id]
		# Use the room's global position as the point position
		astar.add_point(id, room.global_position)

	# 2) Connect each room to its neighbors with the edge cost = lenght of the corridor
	for id in rooms.keys():
		var room = rooms[id]
		for nid in room.waypoints:
			# add_connection(from,to,bidirectional:boolean)
			if not astar.are_points_connected(id, nid):
				# cost of the transition is lenght of the corridor
				var cost = room.lenght
				astar.connect_points(id, nid, true)
				# (by default AStar2D uses Euclidean distance between points as cost,
				# so you can omit custom cost setting if you want simple distance-based cost)

	
