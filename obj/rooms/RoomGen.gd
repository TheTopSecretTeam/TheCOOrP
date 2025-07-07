extends Node
enum RoomType {
	ELEVATOR,
	CORRIDOR,
	CHAMBER
}

## Global Room seed
var room_seed: int = 52
## GLobal Room RNG
var room_rng = RandomNumberGenerator.new()
const chamber_after_corridor_probability = 0.33333333
const room_type_to_res: Dictionary[RoomType, PackedScene] = {
	RoomType.ELEVATOR: preload("res://obj/rooms/elevator.tscn") as PackedScene,
	RoomType.CORRIDOR: preload("res://obj/rooms/corridor.tscn") as PackedScene,
	RoomType.CHAMBER: preload("res://obj/rooms/chamber.tscn") as PackedScene
}

var connector_pool: Dictionary[Vector2i, Array] = {}
var unlinked_connectors: Array[Connector] = []

const opposite_connector: Dictionary[String, String] = {
	"l": "r",
	"r": "l",
	"u": "d",
	"d": "u",
	"cl": "waypoint",
	"cc": "waypoint",
	"cr": "waypoint"
}

func get_keys(a: Array[Connector]) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for i in a:
		result.append(i.map_slot)
	return result

func pool_sanity_check() -> bool:
	for k in connector_pool:
		if connector_pool[k] != null && not connector_pool[k].is_empty():
			var link_state = connector_pool[k][0].linked
			for i in connector_pool[k]:
				if i.to_type != RoomGen.RoomType.CHAMBER && i.linked != link_state:
					return false # Found pool linking inconsistency
	return true # All OK
