extends CanvasLayer
class_name Lobby

# Signals for game events (optional, for future expansion)
signal start_game
signal join_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.players_changed.connect(update_players_list)
	# Connect button signals
	var exit_button = $VBox/HBox/Exit
	exit_button.pressed.connect(_on_exit_button_pressed)
	var start_button = $VBox/HBox/Start
	if !multiplayer.is_server(): 
		start_button.visible = false
		return
	start_button.pressed.connect(_on_start_button_pressed)


func update_players_list() -> void:
	var list_of_players = $VBox/PlayersList
	list_of_players.clear()
	for peer_id in Global.Players:
		var player_name
		if peer_id == 1: player_name = "🖥️ " + Global.Players[peer_id]["name"] + " (Host)"
		else: player_name = Global.Players[peer_id]["name"]
		list_of_players.add_item("Name: " + player_name)

# Called when the Start button is pressed
func _on_start_button_pressed() -> void:
	startGame()
	
@rpc("authority", "call_local")
func startGame() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn")



# Called when the Exit button is pressed
func _on_exit_button_pressed() -> void:
	# Close multiplayer connection
	if multiplayer.is_server():
		multiplayer.multiplayer_peer.close()
		print("Disconnect: Closed multiplayer peer on server")
	else:
		multiplayer.multiplayer_peer.close()
		print("Disconnect: Disconnected client, peer: ", multiplayer.get_unique_id())

	# Remove all other nodes in the scene tree
	var excluded_nodes = [Agents, Global, FacilityNavigation, Map]
	var current_scene = get_tree().current_scene  # Save current scene
	
	# Delete all scenes except this
	for child in get_tree().root.get_children():
		print(child.name)
		if child != current_scene and child not in excluded_nodes:
			child.queue_free()

	for v in excluded_nodes:
		v._reset()

	# Unpause and switch to main menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	print("Disconnect: Switched to main_menu.tscn")
