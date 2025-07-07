extends Node2D
class_name Connector
@export var to_type: RoomGen.RoomType
@export var map_slot: Vector2i
@export var linked: bool = false

func get_parent_room() -> Room:
	var r: Room = get_node_or_null(^"../..")
	assert(r != null, "Connector has no parent Room.")
	return r
