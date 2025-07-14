extends Node

@export var sync_interval: float = 0.5
var timer: Timer

func _ready():
	pass
	print("Sync manager initialized for peer: ", multiplayer.get_unique_id())
	
	# Connect to player changes
	Global.players_changed.connect(_on_players_changed)
	
	if multiplayer.is_server():
		setup_timer()
		print("Server sync started with interval: ", sync_interval, "s")

func _on_players_changed():
	if multiplayer.is_server():
		# Force immediate sync when players change
		_on_timer_timeout()


func setup_timer():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = sync_interval
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	if not multiplayer.is_server():
		return
		
	#print("Server sync cycle started")
	@warning_ignore("unused_variable")
	var sync_count = 0
	
	for node in get_tree().get_nodes_in_group("Sync"):
		if node == null or not is_instance_valid(node):
			continue
			
		if node.has_method("get_sync_data"):
			var node_name = node.get_path()
			if has_node(node_name):  # Check if node exists
				sync_node.rpc(node.name, node.get_sync_data())
				sync_count += 1
	
	#print("Server synchronized ", sync_count, " nodes")

@rpc("any_peer", "reliable")
func sync_node(node_name: String, data: Dictionary):
	if multiplayer.is_server():  # Server don't have to apply sync
		return
		
	var node = find_node_by_name(node_name)
	if node == null:
		push_warning("Sync target not found: ", node_name)
		return
		
	if not is_instance_valid(node):
		push_warning("Sync target invalid: ", node_name)
		return
		
	if node.has_method("apply_sync_data"):
		node.apply_sync_data(data)
		print("Peer ", multiplayer.get_unique_id(), " applied sync for ", node.name)
	else:
		push_warning("Node missing apply_sync_data: ", node_name)


func find_node_by_name(node_name: String) -> Node:
	var root = get_tree().root
	return _find_node_recursive(root, node_name)

func _find_node_recursive(current_node: Node, target_name: String) -> Node:
	if current_node.name == target_name and current_node.is_in_group("Sync"):
		return current_node

	for child in current_node.get_children():
		var found_node = _find_node_recursive(child, target_name)
		if found_node != null:
			return found_node

	return null
