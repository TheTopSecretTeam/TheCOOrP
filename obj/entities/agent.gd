extends PathFollow2D

class_name Agent

var agent_resource : Resource

# stack of rooms left to visit in a trace
var path : Array = []
var current_room: int

var state : int = WANDER
var waypoint : Node2D
enum {
	WANDER,
	GOTO,
	STANDING
}

@export var agent_name : String = "Brad"
@export var speed : float = 0.1

func _ready() -> void:
	$Name.text = agent_name
	
	
func load_path(path_id:Array) -> void:
	path = path_id


func _on_travel():
	if path.is_empty(): 
		state = WANDER 
		return
		
	state = GOTO
	print(path)
	current_room = path.pop_front()
	
	if path.is_empty(): 
		state = WANDER 
		return
	
	waypoint = get_parent().get_parent().get_waypoint(path[0])
	

func _process(delta: float) -> void:
	match state:
		WANDER:
			progress_ratio += speed * delta
		GOTO:
			var raw_delta = waypoint.progress_ratio - progress_ratio
			
			var target = progress_ratio + raw_delta
			progress_ratio = move_toward(progress_ratio, target, speed * delta)
			
			progress_ratio = wrapf(progress_ratio, 0.0, 1.0)
				
			if abs(progress_ratio - waypoint.progress_ratio) < 0.001:
				var nextRoom = waypoint.leading_room
				progress_ratio = nextRoom.waypoints[current_room].progress_ratio
				
				self.visible = false
				self.global_position = nextRoom.global_position
				await get_tree().process_frame
				self.visible = true
				
				nextRoom.transfer(self)
				
