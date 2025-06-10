extends PathFollow2D

class_name Agent

var agent_resource : Resource

# stack of rooms left to visit in a trace
var path : Array = []
var current_room: Room = null

var state : int = WANDER
var waypoint : float = 300.0
var progress_tween : Tween
enum {
	WANDER,
	GOTO
}

@export var agent_name : String = "Brad"
@export var speed : float = 100.0

func _ready() -> void:
	$Name.text = agent_name
	
	
func load_path(path_id:Array) -> void:
	path = path_id


func move_to_room() -> void:
	state = GOTO
	


func _physics_process(delta: float) -> void:
	match state:
		WANDER:
			progress += speed * delta
		GOTO:
			progress = move_toward(progress, waypoint, speed * delta)
