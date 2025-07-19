extends Control
class_name Map

@onready var net_manager = preload("res://net/scripts/net_manager.gd").new()
@onready var tab_menu = preload("res://UI/tabMenu/TabMenu.tscn").instantiate()


@onready var camera = $Camera
@onready var inventory_button = $CanvasLayer/InventoryButton

var net_manager_instance: Node

func _ready():
	add_child(net_manager)
	add_child(tab_menu)
	tab_menu.hide()
	
	Agents.load_agents() #do this after adding agents!
	Agents.agent_died.connect(_on_agent_died)
	Agents.send_agent.connect(send_agent.rpc)
	
	if not is_instance_valid(net_manager):
		push_error("Failed to initialize net manager!")
		return
	SyncManager.setup_timer()

func get_cursor_node():
	return $CanvasLayer

func _process(_delta):
	var cursor_pos = get_global_mouse_position()
	var selected_thing
	var multi_agent_button = Input.is_action_pressed("shift_lmb")
	if multi_agent_button or Input.is_action_just_pressed("clickLeftMouse"):
		selected_thing = get_thing_under_cursor(cursor_pos)
		if !selected_thing: return
		if selected_thing is Agent and not selected_thing.working and not selected_thing in Agents.selected_agents:
			if not multi_agent_button and not Agents.selected_agents.is_empty():
				for a in Agents.selected_agents:
					a.set_outline_visibility(false)
				Agents.selected_agents.clear()
			Agents.selected_agents.append(selected_thing)
			selected_thing.set_outline_visibility(true)
	elif Input.is_action_just_pressed("clickRightMouse"):
		selected_thing = get_thing_under_cursor(cursor_pos)
		if selected_thing is Room and selected_thing is not AnomalyChamber:
			if not Agents.selected_agents.is_empty():
				for a in Agents.selected_agents:
					send_agent.rpc(a.entity_resource.agent_name, selected_thing.get_index())

@rpc("any_peer", "call_local")
func send_agent(agent_name, room_index: int) -> void:
	var agent: Agent
	for node in get_tree().get_nodes_in_group("Agent"):
		if node.entity_resource.agent_name == agent_name:
			agent = node
	if !agent:
		print("agent_not_found");
		return
	if agent.working:
		return
	SyncManager._on_timer_timeout()
	while (agent.current_room == null): get_tree().get_frame()
	var path = FacilityNavigation.get_agent_path(agent.current_room, room_index)
	if path == []:
		return
	agent.path = path
	agent._on_travel()
	return
	
func _on_agent_died(agent: Agent):
	Agents.selected_agents.erase(agent)

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

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action("clickLeftMouse"):
		return
	print("Deselecting the agents")
	for a in Agents.selected_agents:
		a.set_outline_visibility(false)
	Agents.selected_agents = []


func _on_menu_open() -> void:
	camera.zoomable = false
	inventory_button.visible = false

func _on_menu_close() -> void:
	camera.zoomable = true
	inventory_button.visible = true
