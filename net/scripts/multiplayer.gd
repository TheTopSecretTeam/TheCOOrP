extends Control

@export var ipaddr = "127.0.0.1"
@export var port = 8888
var peer
var color = 1

func _ready() -> void:
	multiplayer.peer_connected.connect(PlayerConnected)
	multiplayer.peer_disconnected.connect(PlayerDisconnected)
	multiplayer.connected_to_server.connect(successful_connection)
	multiplayer.connection_failed.connect(failed_to_connect)

# In PlayerConnected function, update to:
func PlayerConnected(id):
	print("Player: " + str(id) + " connected")
	SendPlayerColor(id)
	# wait until client gets its color from server
	while Global.color == null:
		await get_tree().process_frame
	SendPlayerInformation.rpc_id(id, $name.text, Global.color, multiplayer.get_unique_id())
	if multiplayer.is_server():
		startGame.rpc_id(id)  # Changed to call on all peers

func PlayerDisconnected(id):
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

func successful_connection():
	print("Successful connection to server")

func failed_to_connect():
	print("Couldn't connect")


func SendSeed():
	if multiplayer.is_server():
		Global.Seed = randi_range(-1000, 1000)
		RecieveSeed.rpc(Global.Seed)

@rpc("any_peer", "call_local")
func RecieveSeed(seed: int):
	Global.Seed = seed



@rpc("any_peer")
func SendPlayerInformation(player_name: String, player_color: int, id: int):
	if !Global.Players.has(id):
		Global.add_player(id, { "name": player_name, "color": player_color } )
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

@rpc("any_peer", "call_local")
func startGame():
	var scene = load("res://scenes/map.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _on_host_button_down() -> void:
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
	SendPlayerInformation($name.text, Global.color, multiplayer.get_unique_id())

func _on_connect_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client($name2.text, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
