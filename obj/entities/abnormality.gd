extends Entity

@export var anomaly_res: AbnormalityResource
@export var behavior_instance: GDScript

var path : Array = []
var state : int = WANDER

enum {
	WANDER,
	GOTO,
	CHAMBER,
	COMBAT
}
var waypoint : Node2D
var flipped : bool = false:
	set(value):
		if value:
			self.scale.x = -1
			anomaly_res.travel_speed = -1 * abs(anomaly_res.travel_speed)
		else:
			self.scale.x = 1
			anomaly_res.travel_speed = abs(anomaly_res.travel_speed)
		flipped = value

func _ready() -> void:
	super._ready()
	entity_resource = anomaly_res  # Connect the resource reference

func flip():
	flipped = !flipped

func _on_travel():
	if path.is_empty(): 
		state = WANDER 
		return
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
	state = CHAMBER
	flipped = false

func _process(delta: float) -> void:
	match state:
		WANDER:
			var prev_prog = progress
			progress += anomaly_res.travel_speed * delta
			if progress == prev_prog:
				flip()
			super._process(delta)
		GOTO:
			progress = move_toward(
				progress, waypoint.progress, abs(anomaly_res.travel_speed) * delta
			)
			if progress == waypoint.progress:
				waypoint.leading_room.transfer(self, current_room)
		COMBAT:
			super._process(delta)

func handle_combat(delta: float) -> void:
	if (not target or not target.entity_resource.is_alive()) and state != GOTO:
		target = find_target()
		if target:
			state = COMBAT
			var target_progress = target.progress
			var direction = sign(target_progress - progress)
			if direction == -1: self.scale.x = -1
			else: self.scale.x = 1
		else:
			state = WANDER
		return
	
	if state != COMBAT:
		state = COMBAT
	
	super.handle_combat(delta)

func move_toward_target(delta: float) -> void:
	if not target or not current_room_path:
		return
	
	var target_progress = target.progress
	var direction = sign(target_progress - progress)
	if direction == -1: self.scale.x = -1
	else: self.scale.x = 1
	progress += direction * entity_resource.travel_speed * delta
	
