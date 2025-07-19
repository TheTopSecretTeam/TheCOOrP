extends Node

@export var sync_interval: float = 0.5
var timer: Timer

func _ready() -> void:
	Global.reset_globals.connect(reset)
	Global.players_changed.connect(_on_players_changed)
	print("Multiplayer uid: ", multiplayer.get_unique_id())

func reset() -> void:
	if timer != null and is_instance_valid(timer): timer.queue_free()
	setup_timer()

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
			sync_node.rpc(node.get_path(), node.get_sync_data())
			sync_count += 1
	
	#print("Server synchronized ", sync_count, " nodes")

@rpc("any_peer", "reliable")
func sync_node(node_name: NodePath, data: Dictionary):
	if multiplayer.is_server():  # Server don't have to apply sync
		return
		
	var node = get_node_or_null(node_name)
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
