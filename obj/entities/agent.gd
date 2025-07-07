# agent.gd
extends Entity
class_name Agent

var state: int = WANDER
enum {
	WANDER,
	GOTO,
	CHAMBER,
	COMBAT
}
var working = false

func _ready() -> void:
	super._ready()
	$Name.text = entity_resource.agent_name

func get_global_rect():
	return $ClickRect.get_global_rect()

func _on_travel():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("walk")
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
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("idle")
	state = CHAMBER
	flipped = false

func _process(delta: float) -> void:
	match state:
		WANDER:
			var prev_prog = progress
			progress += entity_resource.travel_speed * delta
			if progress == prev_prog:
				flip()
			super._process(delta)
		GOTO:
			progress = move_toward(
				progress, waypoint.progress, abs(entity_resource.travel_speed) * delta
			)
			if progress == waypoint.progress:
				waypoint.leading_room.transfer(self, current_room)
		COMBAT:
			super._process(delta)

func handle_combat(delta: float) -> void:
	if state == GOTO:
		return
	if (not target or not target.entity_resource.is_alive()):
		target = find_target()
		if target:
			state = COMBAT
			var target_progress = target.progress
			var direction = sign(target_progress - progress)
			if direction == -1: $Skeleton.scale.x = -0.5
			else: $Skeleton.scale.x = 0.5
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
	if direction == -1: $Skeleton.scale.x = -0.5
	else: $Skeleton.scale.x = 0.5
	progress += entity_resource.travel_speed * delta
	
func set_outline_visibility(_visible: bool = true):
	$Panel.visible = _visible
	
func die() -> void:
	Global.agent_died.emit(self)
	super.die()

# NET
#func get_sync_data() -> Dictionary:
	#print("Received data from server.")
	#var data = super.get_sync_data()
	#data["state"] = state
	#data["current_room"] = current_room
	#return data
#
#func apply_sync_data(data: Dictionary) -> void:
	#print("Applying synchronization...")
	#super.apply_sync_data(data)
	#state = data["state"]
	#current_room = data["current_room"]
