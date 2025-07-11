extends Entity
class_name Abnormality

@onready var skeleton: Node2D = $Skeleton
@onready var health_container: HBoxContainer = $HealthBar
@onready var health_bar: TextureProgressBar = $HealthBar/HealthBackground/HealthForeground
@onready var health_text: Label = $HealthBar/HealthText

var state: int = CHAMBER

enum {
	WANDER,
	GOTO,
	CHAMBER,
	COMBAT
}

func _ready() -> void:
	super._ready()
	update_health_display()
	
func update_health_display() -> void:
	if health_bar:
		health_bar.max_value = entity_resource.max_hp
		health_bar.value = entity_resource.current_hp
		if health_text:
			health_text.text = "%d/%d HP" % [entity_resource.current_hp, entity_resource.max_hp]

func take_damage(amount: int, type: String) -> void:
	super.take_damage(amount, type)
	update_health_display()
		
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

#func move_toward_target(delta: float) -> void:
	#if not target or not current_room_path:
		#return
	#
	#var target_progress = target.progress
	#var direction = sign(target_progress - progress)
	#progress += entity_resource.travel_speed * delta
