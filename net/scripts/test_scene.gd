extends Node2D

var CursorScene = preload("res://net/cursor/cursor.tscn")
var numberOfPlayers = GameManager.Players.size()
var cursors = {}

func _ready() -> void:
	# Wait one frame to ensure all player data is synchronized
	await get_tree().process_frame
	# Create cursors for all players
	for player_id in GameManager.Players:
		create_cursor(player_id)
		
func _process(delta: float) -> void:
	# Add new cursors
	for player_id in GameManager.Players:
		if not cursors.has(player_id):
			create_cursor(player_id)

	# Remove disconnected cursors
	for player_id in cursors.keys():
		if not GameManager.Players.has(player_id):
			remove_child(cursors[player_id])
			cursors.erase(player_id)

func create_cursor(player_id):
	var cursor = CursorScene.instantiate()
	cursor.color = GameManager.Players[player_id].color
	cursor.player_id = player_id
	cursor.name = "Cursor_%d" % player_id
	cursors[player_id] = cursor
	add_child(cursor)
	
	# Set initial position for local player
	if player_id == multiplayer.get_unique_id():
		cursor.global_position = get_global_mouse_position()
