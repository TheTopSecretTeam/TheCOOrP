extends Node

@export var sync_interval: float = 1.0
var timer: Timer

func _ready():
	pass
	print("Sync manager initialized for peer: ", multiplayer.get_unique_id())
	
	if multiplayer.is_server():
		setup_timer()
		print("Server sync started with interval: ", sync_interval, "s")

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
			var node_path = node.get_path()
			if has_node(node_path):  # Проверка что узел существует
				sync_node.rpc(node_path, node.get_sync_data())
				sync_count += 1
	
	#print("Server synchronized ", sync_count, " nodes")

@rpc("any_peer", "reliable")
func sync_node(node_path: NodePath, data: Dictionary):
	if multiplayer.is_server():  # Серверу не нужно применять синхронизацию
		return
		
	var node = get_node_or_null(node_path)
	if node == null:
		push_warning("Sync target not found: ", node_path)
		return
		
	if not is_instance_valid(node):
		push_warning("Sync target invalid: ", node_path)
		return
		
	if node.has_method("apply_sync_data"):
		node.apply_sync_data(data)
		print("Peer ", multiplayer.get_unique_id(), " applied sync for ", node.name)
	else:
		push_warning("Node missing apply_sync_data: ", node_path)
