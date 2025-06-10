extends Node2D

var arrow_texture
var color
var player_id
var is_local_player = false

func _ready() -> void:
	# Load the appropriate cursor texture
	arrow_texture = load("res://img/cursor_images/" + str(color) + ".png")
	
	# Set up input processing only for local player
	is_local_player = player_id == multiplayer.get_unique_id()
	set_process_input(is_local_player)
	
	# For local player, set system cursor
	if is_local_player:
		Input.set_custom_mouse_cursor(arrow_texture)
	else:
		# For remote players, create a visible sprite
		var sprite = Sprite2D.new()
		sprite.texture = arrow_texture
		sprite.name = "CursorSprite"
		add_child(sprite)

func _input(event):
	if event is InputEventMouseMotion:
		update_position.rpc(event.global_position)

@rpc("unreliable", "any_peer")
func update_position(pos: Vector2):
	global_position = pos
