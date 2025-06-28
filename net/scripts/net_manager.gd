extends Node2D

var CursorScene = preload("res://net/cursor/cursor.tscn")
var numberOfPlayers = Global.Players.size()
var cursors = {}

func _ready():
	if multiplayer.has_multiplayer_peer():
		print("Multiplayer ready!")
		
func _process(_delta: float) -> void:
	# Add new cursors
	for player_id in Global.Players:
		if not cursors.has(player_id):
			create_cursor(player_id)

	# Remove disconnected cursors
	for player_id in cursors.keys():
		if not Global.Players.has(player_id):
			remove_child(cursors[player_id])
			cursors.erase(player_id)

func create_cursor(player_id):
	var cursor = CursorScene.instantiate()
	cursor.color = Global.Players[player_id].color
	cursor.player_id = player_id
	cursor.name = "Cursor_%d" % player_id
	cursors[player_id] = cursor
	get_parent().get_cursor_node().add_child(cursor)
	
	# Set initial position for local player
	if player_id == multiplayer.get_unique_id():
		cursor.global_position = get_viewport().canvas_transform.origin +get_viewport().get_mouse_position()
