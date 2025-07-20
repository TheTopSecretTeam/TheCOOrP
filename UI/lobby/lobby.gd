extends Control
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
	update_players_list()


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
	#var saved_scene = ResourceLoader.load("res://save1.tscn").instantiate()
	startGame.rpc()

@rpc("authority", "call_local")
func startGame() -> void:
	if multiplayer.is_server():
		if Global.loading:
			get_tree().change_scene_to_file(Global.save_file_path)
		else:
			get_tree().change_scene_to_file("res://scenes/map.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/map.tscn")
	#if !is_instance_valid(saved_scene): print("error"); return
	#get_tree().change_scene_to_file("res://scenes/map.tscn")

# Called when the Exit button is pressed
func _on_exit_button_pressed() -> void:
	SyncManager.leave_map()
	print("Disconnect: Switched to main_menu.tscn")
