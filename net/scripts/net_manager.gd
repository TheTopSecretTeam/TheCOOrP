extends Node2D

var CursorScene = preload("res://net/cursor/cursor.tscn")
var numberOfPlayers: int:
	get:
		return Global.Players.size()
var cursors = {}

func _ready():
	if multiplayer.has_multiplayer_peer():
		print("Multiplayer ready!")
		# Connect to Global signals
		Global.player_added.connect(_on_player_added)
		Global.player_removed.connect(_on_player_removed)
		Global.player_updated.connect(_on_player_updated)

func _on_player_added(player_id: int, _player_data: Dictionary):
	create_cursor(player_id)

func _on_player_removed(player_id: int):
	if cursors.has(player_id):
		remove_child(cursors[player_id])
		cursors.erase(player_id)

func _on_player_updated(player_id: int, key: String, value):
	if key == "color" and cursors.has(player_id):
		cursors[player_id].update_color(value)
		
		
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
