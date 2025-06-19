extends Room


func _ready() -> void:
	for child in $room_path.get_children():
		if child is Waypoint:
			if child.leading_room:
				waypoints[child.leading_room.get_index()] = child
				#if self.get_index() == 0: print(child.leading_room.get_index())

func transfer(agent: Agent, _previous_room):
	agent.reparent($CharacterMarker)
	agent.position = Vector2.ZERO
	agent._on_travel()
	agent.state = 2
#gg