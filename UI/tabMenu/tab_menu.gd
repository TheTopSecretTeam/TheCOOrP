extends Control

@onready var item_container = $CenterContainer/VBoxContainer/PlayersList
#@onready var save_button = $CenterContainer/VBoxContainer/Save

func _ready():
	# Connect to all player change signals
	Global.players_changed.connect(update_player_list)
	item_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		toggle_scene_visibility()

var scene_visible := false

func toggle_scene_visibility() -> void:
	scene_visible = !scene_visible
	self.visible = scene_visible
	if scene_visible:
		update_player_list()


func update_player_list():
	# Clear existing entries
	for child in item_container.get_children():
		child.queue_free()
	
	# Add current players
	for player_id in Global.Players:
		var player_data = Global.Players[player_id]
		create_player_entry(player_id, player_data)

func create_player_entry(player_id: int, player_data: Dictionary):
	var hbox = HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.custom_minimum_size = Vector2(0, 40)
	hbox.set_meta("player_id", player_id)  # Store ID for reference

	# Player name label
	var label = Label.new()
	label.text = "%s (ID: %d)" % [player_data["name"], player_id]
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

	# Kick button (server only)
	if multiplayer != null && multiplayer.is_server() && player_id != 1:
		var btn_kick = Button.new()
		btn_kick.text = "Kick"
		btn_kick.pressed.connect(_on_kick_pressed.bind(player_id))
		hbox.add_child(btn_kick)

	hbox.add_child(label)
	item_container.add_child(hbox)

func _on_kick_pressed(player_id):
	if multiplayer != null && multiplayer.is_server():
		get_multiplayer().disconnect_peer(player_id)
		player_kicked.rpc(player_id)
		update_player_list()

@rpc("any_peer", "call_local")
func player_kicked(player_id):
	# Handle player kicked notification
	if Global.Players.has(player_id):
		Global.Players.erase(player_id)
	update_player_list()
