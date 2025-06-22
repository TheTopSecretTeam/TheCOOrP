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
			$Skeleton.scale.x = -0.5
			speed = -1 * abs(speed)
		else:
			$Skeleton.scale.x = 0.5
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

# NET
func get_sync_data() -> Dictionary:
	print("Recieved data from server.")
	return {
		"progress": progress,
		"flipped": flipped,
		"room": get_parent().get_path(),
		"path": path.duplicate(),
		"state": state,
		"current_room": current_room
	}

func apply_sync_data(data: Dictionary) -> void:
	print("Applying synchronization...")
	
	var new_parent = get_node_or_null(data["room"])
	if new_parent and new_parent != get_parent():
		# Save global position
		var global_pos = global_position
		var global_rot = global_rotation
			
		# Reparent
		get_parent().remove_child(self)
		new_parent.add_child(self)
		
		# Restore position
		global_position = global_pos
		global_rotation = global_rot
		
	progress = data["progress"]
	flipped = data["flipped"]
	path = data["path"]
	state = data["state"]
	current_room = data["current_room"]
