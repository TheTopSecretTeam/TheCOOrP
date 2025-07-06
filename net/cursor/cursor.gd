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
	
	# For local player, set system cursor with centered hotspot
	if is_local_player && arrow_texture:
		var hotspot = Vector2(arrow_texture.get_width()/2, arrow_texture.get_height()/2)
		Input.set_custom_mouse_cursor(arrow_texture, Input.CURSOR_ARROW, hotspot)
	else:
		# For remote players, create a visible sprite
		if arrow_texture:
			var sprite = Sprite2D.new()
			sprite.texture = arrow_texture
			sprite.name = "CursorSprite"
			sprite.centered = true
			add_child(sprite)

# На стороне отправителя
func _input(event):
	if event is InputEventMouseMotion:
		# Преобразуем экранные координаты в мировые
		var world_pos = get_viewport().get_camera_2d().get_global_mouse_position()
		update_position.rpc(world_pos)

# На стороне получателя
@rpc("unreliable", "any_peer")
func update_position(world_pos: Vector2):
	# Устанавливаем позицию напрямую в мировых координатах
	# Спрайт уже центрирован, поэтому смещение не нужно
	global_position = world_pos
