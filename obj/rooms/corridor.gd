extends Node2D
class_name Room

var neighbors : Array = []
var agents : Dictionary = {
}
var lenght = 1

func _ready() -> void:
	pass
	#for child in $room_path.get_children():
		##if child is Waypoint:
			##if child.leading_room:
				##neighbors.append(child.leading_room)
		#if child is Agent:
			#agents[child.agent_name] = child
		
func _add_agent(agent: Agent) -> void:
	agents[agent.agent_name] = agent
		
		
func _add_neighbor(room:Room) -> void:
	# add in both directions
	neighbors.append(room)
	if not self in room.neighbors:
		room.neighbors.append(self)
