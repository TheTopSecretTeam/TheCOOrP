extends Control
class_name Room

var waypoints : Dictionary = {}
var agents : Dictionary = {
}
var lenght = 1

func _ready() -> void:
	for child in $room_path.get_children():
		if child is Waypoint:
			if child.leading_room:
				waypoints[child.leading_room.get_index()] = child
				#if self.get_index() == 0: print(child.leading_room.get_index())
		if child is Agent:
			agents[child.agent_name] = child


func _add_agent(agent: Agent) -> void:
	agents[agent.agent_name] = agent
	get_child(1).add_child(agent)

func _size() -> Vector2:
	return Vector2(759, 118) * self.global_transform.get_scale()

func get_waypoint(index : int) -> Node2D:
	return waypoints[index]

func transfer(agent: Agent):
	agent.reparent($room_path)
	agent._on_travel()
