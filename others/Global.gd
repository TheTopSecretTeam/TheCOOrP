extends Node

signal reset_globals

var Players = {}
var cursors = {}
var color
var Seed : int

signal resources_changed(new_resources)
# Player management signals
signal player_added(player_id, player_data)
signal player_removed(player_id)
signal player_updated(player_id, key, value)
signal players_changed() # General signal for any change

@onready var sync_manager = preload("res://net/scripts/sync_manager.gd").new()

func _ready() -> void:
	reset_globals.connect(reset)
	add_child(sync_manager)
	if not is_instance_valid(sync_manager):
		push_error("Failed to initialize sync manager!")
		return

func reset():
	if resources_changed.has_connections(): Helpers.disconnect_all(resources_changed)
	if energy_changed.has_connections(): Helpers.disconnect_all(energy_changed)
	if quota_reached.has_connections(): Helpers.disconnect_all(quota_reached)
	resources = {
		"Materials": 12,
		"Funds": 12,
		"Radiance": 12,
		"Blight": 12,
		}
	rng = RandomNumberGenerator.new()
	Players.clear()
	color = null
	Seed = 0
	current_energy = 0
	energy_quota = 10
	# print("Global: Reset all properties, peer: ", multiplayer.get_unique_id())

# TODO remake
# func clearCursors() -> void:
# 	for child in Map.get_children():
# 		if child is Cursor:
# 			print(child.get_index(), child.name)
# 			Map.remove_child(child)
# 			child.queue_free()

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


var resources: Dictionary[String, int] = {
	"Materials": 12,
	"Funds": 12,
	"Radiance": 12,
	"Blight": 12,
	}

var rng = RandomNumberGenerator.new()
var energy_quota: int = 10
var current_energy: int = 0:
	set(value):
		current_energy = value
		energy_changed.emit(current_energy)
		if energy_quota <= current_energy:
			quota_reached.emit()

signal energy_changed
signal quota_reached
