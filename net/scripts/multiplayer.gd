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
	while GameManager.color == null:
		await get_tree().process_frame
	SendPlayerInformation.rpc_id(id, $name.text, GameManager.color, multiplayer.get_unique_id())
	if multiplayer.is_server():
		startGame.rpc_id(id)  # Changed to call on all peers

func PlayerDisconnected(id):
	print("Player: " + str(id) + " disconnected")

func successful_connection():
	print("Successful connection to server")

func failed_to_connect():
	print("Couldn't connect")

# Update SendPlayerInformation to include color
@rpc("any_peer")
func SendPlayerInformation(name: String, color: int, id: int):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id,
			"color": color  # Store the assigned color
		}
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, color, i)

func SendPlayerColor(id: int):
	if multiplayer.is_server():
		var assigned_color = color
		color += 1
		ReceivePlayerColor.rpc_id(id, assigned_color)

@rpc("any_peer", "call_local")
func ReceivePlayerColor(received_color: int):
	GameManager.color = received_color
	print("Received cursor color: ", received_color)

@rpc("any_peer", "call_local")
func startGame():
	var scene = load("res://test_scene.tscn").instantiate()
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

	# Host gets their own color too
	SendPlayerColor(multiplayer.get_unique_id())
	startGame.rpc_id(1)
	SendPlayerInformation($name.text, GameManager.color, multiplayer.get_unique_id())

func _on_connect_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ipaddr, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
