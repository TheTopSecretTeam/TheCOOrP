extends Control
class_name Room

var waypoints : Dictionary[int, PathFollow2D] = {}
var connectors: Array[Connector] = []

@export var room_type: RoomGen.RoomType

func _ready() -> void:
	pass

func populate_nav_graph() -> void:
	FacilityNavigation.graph[get_index()] = []
	for child in $room_path.get_children():
		if child is Waypoint:
			if child.leading_room:
				FacilityNavigation.graph[get_index()].append(child.leading_room.get_index())
				waypoints[child.leading_room.get_index()] = child
		if child is Agent:
			child.current_room = get_index()

func get_waypoint(index : int) -> PathFollow2D:
	return waypoints[index]

func transfer(entity: Entity, previous_room):
	entity.reparent($room_path)
	entity.progress = waypoints[previous_room].progress
	entity._on_travel()

func highlight():
	pass

func get_connectors(apply_offset: Vector2i = Vector2i(0, 0)) -> Array[Connector]:
	if connectors == []:
		var container = get_node_or_null(^"connectors")
		if container == null:
			return connectors
		connectors.assign(container.get_children())
		for i in connectors:
			i.map_slot += apply_offset
	return connectors

## Get chamber Connectors. Avaliable only for RoomType.CORRIDOR
func get_chamber_slots() -> Array[Connector]:
	assert(room_type == RoomGen.RoomType.CORRIDOR, "Only RoomType.CORRIDOR have chamber slots")
	return [get_node(^"connectors/cl"), get_node(^"connectors/cc"), get_node(^"connectors/cr")]

func connect_room(connector: Connector, room: Room, recurse_connectors: bool = true, new_room: bool = true) -> void:
	assert(not (self is AnomalyChamber), "AnomalyChamber has no connectors, and therefore cannot be connected.")
	assert(connectors != null, "Cannot check for neighbors without using get_connectors() first")
	# Waypoint linking
	($room_path.find_child(connector.name) as Waypoint).leading_room = room
	(room.get_node("room_path/" + RoomGen.opposite_connector[connector.name]) as Waypoint).leading_room = self
	# Connector linking
	connector.linked = true
	RoomGen.unlinked_connectors.erase(connector)
	if connector.to_type == RoomGen.RoomType.CHAMBER:
		return
	var opposite_connector = room.get_node("connectors/" + RoomGen.opposite_connector[connector.name]) 
	opposite_connector.linked = true
	if not new_room:
		RoomGen.unlinked_connectors.erase(opposite_connector)
	# Check for neighbors and recursivly connect them
	if not recurse_connectors:
		return
	var a: Array[Connector] = []
	a.assign(RoomGen.connector_pool.get(connector.map_slot))
	for c in a:
		if c.to_type == RoomGen.RoomType.CHAMBER:
			continue
		if c.linked == false:
			c.get_parent_room().connect_room(c, room, false, new_room)
