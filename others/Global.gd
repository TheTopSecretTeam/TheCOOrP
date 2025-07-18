extends Node

var Players = {}
var cursors = {}
var color
var Seed : int

signal resources_changed(new_resources)
# Player management signals
signal player_added(player_id, player_data)
signal player_removed(player_id)
signal player_updated(player_id, key, value)
signal players_changed()  # General signal for any change

@onready var sync_manager = preload("res://net/scripts/sync_manager.gd").new()

func _ready() -> void:
	add_child(sync_manager)
	if not is_instance_valid(sync_manager):
		push_error("Failed to initialize sync manager!")
		return

func _reset():
	Players = {}
	color = null
	Seed = 0
	resources = {
		"Materials": 12,
		"Funds": 12, 
		"Radiance": 12, 
		"Blight": 12,
	}
	current_energy = 0
	energy_quota = 10
	resources_changed.emit(resources)
	energy_changed.emit(current_energy)
	print("Global: Reset all properties, peer: ", multiplayer.get_unique_id())
	
func clearCursors() -> void:
	# clear from cursors
	for child in Map.get_children():
		if child is Cursor:
			print(child.get_index(), child.name)
			Map.remove_child(child)
			child.queue_free()
	
func _process(_delta):
	sync_players_with_peers()

# RPC to notify all clients of a player disconnection
@rpc("authority", "call_local")
func NotifyPlayerDisconnected(id: int):
	if Global.Players.has(id):
		Global.remove_player(id)
	print("Client: Removed player ", id, " from Global.Players")

func sync_players_with_peers() -> void:
	if multiplayer == null or !multiplayer.is_server(): return
	
	var current_peers = multiplayer.get_peers()
	var players = Players.keys()
	if current_peers.size() > players.size(): return
	for peer_id in Players.keys():
		if peer_id != 1 and peer_id not in current_peers:
				NotifyPlayerDisconnected.rpc(peer_id)
				remove_player(peer_id)


func add_player(player_id: int, player_data: Dictionary):
	Players[player_id] = player_data
	player_added.emit(player_id, player_data)
	players_changed.emit()

func remove_player(player_id: int):
	if Players.has(player_id):
		# Update color indices for players with higher indices
		for pid in Global.Players:
			if Global.Players[pid]["color"] > Global.Players[player_id]["color"]:
				update_player(pid, "color", Global.Players[pid]["color"] - 1)

		Players.erase(player_id)
		player_removed.emit(player_id)
		players_changed.emit()

func update_player(player_id: int, key: String, value):
	if Players.has(player_id):
		Players[player_id][key] = value
		player_updated.emit(player_id, key, value)
		players_changed.emit()


var resources = {
	"Materials" : 12,
	"Funds" : 12, 
	"Radiance" : 12, 
	"Blight" : 12,
	}

var rng = RandomNumberGenerator.new()
var energy_quota : int = 10
var current_energy : int = 0:
	set(value):
		current_energy = value
		energy_changed.emit(current_energy)
		if energy_quota <= current_energy:
			quota_reached.emit()

signal energy_changed
signal quota_reached
