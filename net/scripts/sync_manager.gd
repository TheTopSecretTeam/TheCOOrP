extends Node

@export var sync_interval: float = 0.5
var timer: Timer

var ipaddr: String = "127.0.0.1"
var port: int = 8888
var peer: ENetMultiplayerPeer
var color = 1
var playername: String

func _ready() -> void:
	Global.reset_globals.connect(reset)
	Global.players_changed.connect(_on_players_changed)
	print("Multiplayer uid: ", multiplayer.get_unique_id())
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(successful_connection)
	multiplayer.connection_failed.connect(failed_to_connect)

func reset() -> void:
	if timer != null and is_instance_valid(timer): timer.queue_free()

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

func PlayerConnected(id):
	print("Player: " + str(id) + " connected")
	SendPlayerColor(id)
	sync_players_with_peers()
	# wait until client gets its color from server
	while Global.color == null:
		await get_tree().process_frame
	SendPlayerInformation.rpc_id(id, playername, Global.color, multiplayer.get_unique_id())
	if multiplayer.is_server():
		startGame.rpc_id(id) # Changed to call on all peers

func PlayerDisconnected(id):
	# check if peer is not server and disconnected
	# and others in Lobby then just ignore
	sync_players_with_peers()
	if (id != 1):
		if get_tree().current_scene.name == "Lobby":
			return

	print("Player: " + str(id) + " disconnected")
	var disconnected_scene = load("res://UI/HostDiscoonected/host_disconnected.tscn").instantiate()
	get_tree().root.add_child(disconnected_scene)
	get_tree().paused = true

# RPC to notify all clients of a player disconnection
@rpc("authority", "call_local")
func NotifyPlayerDisconnected(id: int):
	if Global.Players.has(id):
		Global.remove_player(id)
	print("Client: Removed player ", id, " from Global.Players")

func sync_players_with_peers() -> void:
	if multiplayer == null or !multiplayer.is_server(): return
	var current_peers = multiplayer.get_peers()
	var players = Global.Players.keys()
	if current_peers.size() > players.size(): return
	for peer_id in Global.Players.keys():
		if peer_id != 1 and peer_id not in current_peers:
				NotifyPlayerDisconnected.rpc(peer_id)
				Global.remove_player(peer_id)

func successful_connection():
	print("Successful connection to server")

func failed_to_connect():
	print("Couldn't connect")

func SendSeed():
	if multiplayer.is_server():
		Global.Seed = randi_range(-1000, 1000)
		RecieveSeed.rpc(Global.Seed)

@rpc("any_peer", "call_local")
func RecieveSeed(_seed: int):
	Global.Seed = _seed

@rpc("any_peer")
func SendPlayerInformation(player_name: String, player_color: int, id: int):
	if !Global.Players.has(id):
		Global.add_player(id, {"name": player_name, "color": player_color, })
	if multiplayer.is_server():
		for player_id in Global.Players:
			SendPlayerInformation.rpc(
				Global.Players[player_id].name,
				Global.Players[player_id].color,
				player_id
			)

func SendPlayerColor(id: int):
	if multiplayer.is_server():
		var assigned_color = Global.Players.size() + 1
		color += 1
		ReceivePlayerColor.rpc_id(id, assigned_color)

@rpc("any_peer", "call_local")
func ReceivePlayerColor(received_color: int):
	Global.color = received_color
	print("Received cursor color: ", received_color)

func HostLobby(_playername: String):
	playername = _playername
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4)
	if error != OK:
		print("Can't host")
		return

	print("Waiting for players!")
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	# send seed
	SendSeed()
	# Host gets their own color too
	SendPlayerColor(multiplayer.get_unique_id())
	startGame.rpc_id(1)
	SendPlayerInformation(playername, Global.color, multiplayer.get_unique_id())

func ConnectToLobby(_playername: String, hostname: String):
	playername = _playername
	peer = ENetMultiplayerPeer.new()
	peer.create_client(hostname, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

@rpc("any_peer", "call_local")
func startGame():
	get_tree().change_scene_to_file("res://UI/lobby/lobby.tscn")

## Gracefully leave the map
func leave_map() -> void:
	# Close multiplayer connection
	if multiplayer.has_multiplayer_peer():
		if multiplayer.is_server():
			print("Disconnect: Closed multiplayer peer on server")
		else:
			print("Disconnect: Disconnected client, peer: ", multiplayer.get_unique_id())
		multiplayer.multiplayer_peer.close()

	Global.reset_globals.emit()
	# Unpause and switch to main menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	print("Disconnect: Switched to main_menu.tscn")
