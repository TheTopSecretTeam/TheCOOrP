extends Node

var Players = {}
var color

signal resources_changed(new_resources)
# Player management signals
signal player_added(player_id, player_data)
signal player_removed(player_id)
signal player_updated(player_id, key, value)
signal players_changed()  # General signal for any change

func add_player(player_id: int, player_data: Dictionary):
	Players[player_id] = player_data
	player_added.emit(player_id, player_data)
	players_changed.emit()

func remove_player(player_id: int):
	if Players.has(player_id):
		Players.erase(player_id)
		player_removed.emit(player_id)
		players_changed.emit()

func update_player(player_id: int, key: String, value):
	if Players.has(player_id):
		Players[player_id][key] = value
		player_updated.emit(player_id, key, value)
		players_changed.emit()

var filepath : String

func load_game() -> void:
	var saving_system = preload("res://saving/saving.gd").new()
	if saving_system.load_game(filepath):
		print("Game loaded successfully from: ", filepath)
	else:
		print("Failed to load game from: ", filepath)


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
