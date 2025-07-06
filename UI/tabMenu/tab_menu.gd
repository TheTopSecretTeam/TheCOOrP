extends Node2D

@onready var item_container = $ScrollContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	update_player_list()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		toggle_scene_visibility()

var scene_visible := false

func toggle_scene_visibility() -> void:
	scene_visible = !scene_visible
	self.visible = scene_visible

func update_player_list():
	for child in item_container.get_children():
		child.queue_free()
		
	for i in Global.Players:
		var player = Global.Players[i]
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var label = Label.new()
		label.text = player["name"]
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT

		var btn_kick = Button.new()
		btn_kick.text = "Kick"
		btn_kick.pressed.connect(_on_kick_pressed.bind(player))

		hbox.add_child(label)
		hbox.add_child(btn_kick)

		hbox.add_spacer(false)
		item_container.add_child(hbox)

func _on_kick_pressed(player):
	pass
