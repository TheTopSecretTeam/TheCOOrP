extends Control
class_name Room

var waypoints : Dictionary = {}

func _ready() -> void:
	for child in $room_path.get_children():
		if child is Waypoint:
			if child.leading_room:
				waypoints[child.leading_room.get_index()] = child
				#if self.get_index() == 0: print(child.leading_room.get_index())
		if child is Agent:
			child.current_room = get_index()

func get_waypoint(index : int) -> Node2D:
	return waypoints[index]

func transfer(entity: Entity, previous_room):
	entity.reparent($room_path)
	entity.progress = waypoints[previous_room].progress
	entity._on_travel()
