extends Control
class_name Room

var waypoints : Dictionary[int, PathFollow2D] = {}

func _ready() -> void:
	populate_nav_graph()

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

# return status
func transfer(entity: Entity, previous_room) -> bool:
	entity.reparent($room_path)
	if (waypoints.get_or_add(previous_room, null) == null): return false
	entity.progress = waypoints[previous_room].progress
	entity._on_travel()
	return true
