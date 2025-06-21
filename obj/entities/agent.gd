extends PathFollow2D

class_name Agent

@export var agent_res : Resource

# stack of rooms left to visit in a trace
var path : Array = []

@export var current_room: int
var state : int = WANDER
enum {
	WANDER,
	GOTO,
	CHAMBER,
}

var waypoint : Node2D
var flipped : bool = false:
	set(value):
		if value:
			$Sprite2D.scale.x = -1
			speed = -1 * abs(speed)
		else:
			$Sprite2D.scale.x = 1
			speed = abs(speed)
		flipped = value

@export var agent_name : String = "Brad" #delete after agent resource
@export var speed : float = 100.0

func _ready() -> void:
	$Name.text = agent_name # change for $Name.text = agent_res.name

func flip():
	flipped = !flipped

#for clicking on agents and selecting them
func get_global_rect():
	return $ClickRect.get_global_rect()

func _on_travel():
	if path.is_empty(): 
		state = WANDER 
		return
	#print(path)
	current_room = path.pop_front()
	if path.size() == 0:
		state = WANDER
		return
	waypoint = get_parent().get_parent().get_waypoint(path[0])
	if state == CHAMBER:
		state = GOTO
		waypoint.leading_room.transfer(self, current_room)
		return
	state = GOTO
	flipped = (waypoint.progress - progress) < 0

func _on_chamber_arrival():
	current_room = path.pop_front()
	path = []
	state = CHAMBER
	flipped = false

func _process(delta: float) -> void:
	match state:
		WANDER:
			var prev_prog = progress
			progress += speed * delta
			if progress == prev_prog:
				flip()
		GOTO:
			progress = move_toward(progress, waypoint.progress, abs(speed) * delta)
			if progress == waypoint.progress:
				#print(true)
				waypoint.leading_room.transfer(self, current_room)
