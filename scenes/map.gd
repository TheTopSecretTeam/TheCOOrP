extends Control

@onready var net_manager = preload("res://net/scripts/net_manager.gd").new()
@onready var sync_manager = preload("res://net/scripts/sync_manager.gd").new()
var net_manager_instance: Node

var selected_agents: Array[Agent] = []

func _ready():
	add_child(net_manager)
	add_child(sync_manager)
	
	RoomGen.room_rng.seed = RoomGen.room_seed
	_generate_map(10, RoomGen.room_rng)
	
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

## Procedurally places rooms at random avaliable connector
func _generate_map(n: int, rng: RandomNumberGenerator):
	# Initialization
	RoomGen.connector_pool[($rooms/root).map_slot] = [$rooms/root]
	
	var connectors: Array[Connector] = $rooms/elevator.get_connectors()
	# connector filter
	connectors.assign(connectors.filter(func (x: Connector): return x.map_slot.y >= 0 || (x.to_type == RoomGen.RoomType.CHAMBER && not x.linked)))
	Type.dict_add_array(RoomGen.connector_pool, RoomGen.get_keys(connectors), connectors)
	RoomGen.unlinked_connectors.append_array(connectors)
	
	var next_room: Room
	var chamber_count: int = 0
	var priority_connector: Connector = null
	var c: Connector
	while chamber_count < n:
		# Select random avaliable connector, if no priority_connector is present.
		if priority_connector == null:
			c = RoomGen.unlinked_connectors[rng.randi_range(0, RoomGen.unlinked_connectors.size() - 1)]
		else:
			c = priority_connector
		# Room instantiation
		next_room = RoomGen.room_type_to_res[c.to_type].instantiate()
		next_room.global_position = c.global_position
		print(c.global_position)
		($rooms).call_deferred("add_child", next_room)
		await Engine.get_main_loop().process_frame
		# Room connection
		connectors = next_room.get_connectors(c.map_slot)
		Type.dict_add_array(RoomGen.connector_pool, RoomGen.get_keys(connectors), connectors)
		c.get_parent_room().connect_room(c, next_room)
		
		if c.to_type == RoomGen.RoomType.CHAMBER:
			chamber_count += 1
			AnomalyChamber.chamber_pool.append(c.get_parent_room() as AnomalyChamber)
			if priority_connector != null:
				priority_connector = null
				var chamber_slots = c.get_parent_room().get_chamber_slots()
				for i in chamber_slots:
					if not i.linked:
						if rng.randf() <= RoomGen.chamber_after_corridor_probability:
							priority_connector = i
						break
		elif c.to_type == RoomGen.RoomType.CORRIDOR: # Decide on amount of anomaly slots, and mark unused connectors as linked
			priority_connector = null
			var chamber_amount = 1 + rng.randi() & 1
			var chamber_slots = next_room.get_chamber_slots()
			if chamber_amount == 1:
				chamber_slots[0].linked = true
				chamber_slots[2].linked = true
			else:
				chamber_slots[1].linked = true
			if rng.randf() <= RoomGen.chamber_after_corridor_probability:
				priority_connector = chamber_slots[(rng.randi() & 1) * 2] if chamber_amount == 2 else chamber_slots[1]
		
		RoomGen.unlinked_connectors.append_array(connectors.filter(func (x: Connector): return not x.linked && x.map_slot.y >= 0))
	print(RoomGen.pool_sanity_check())
	
