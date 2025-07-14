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

@onready var health_bar: TextureProgressBar = $HealthBar/HealthBackground/HealthForeground
@onready var mental_bar: TextureProgressBar = $MentalBar/MentalBackground/MentalForeground
@onready var health_text: Label = $HealthBar/HealthText
@onready var mental_text: Label = $MentalBar/MentalText

@export var highlight_panel: Panel
@export var highlight_panel_trans: Panel

func _ready() -> void:
	super._ready()
	$Name.text = entity_resource.agent_name
	update_health_display()
	
func update_health_display() -> void:
	if health_bar:
		health_bar.max_value = entity_resource.max_hp
		health_bar.value = entity_resource.current_hp
	if mental_bar:
		mental_bar.max_value = entity_resource.max_sp
		mental_bar.value = entity_resource.current_sp
		
	if health_text:
		health_text.text = "%d/%d HP" % [entity_resource.current_hp, entity_resource.max_hp]
	if mental_text:
		mental_text.text = "%d/%d SP" % [entity_resource.current_sp, entity_resource.max_sp]

func take_damage(amount: int, type: String) -> void:
	super.take_damage(amount, type)
	update_health_display()

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
	highlight_panel_trans.visible = get_global_rect().has_point(get_global_mouse_position())
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
	highlight_panel.visible = _visible
	
func die() -> void:
	Agents.agent_died.emit(self)
	super.die()

# NET & saving
func get_sync_data() -> Dictionary:
	return {
				"name": entity_resource.agent_name,
				"progress": progress,
				"state": state,
				"working": working,
				"health": entity_resource.current_hp,
				"flipped": flipped,
				"current_room": current_room,
				"path": path,
				"waypoint": (
					null if waypoint == null or not waypoint.is_inside_tree()
					else waypoint.get_path()
				)
			}

func apply_sync_data(agent_data: Dictionary) -> void:
	progress = agent_data["progress"]
	state = agent_data["state"]
	working = agent_data["working"]
	entity_resource.current_hp = agent_data["health"]
	flipped = agent_data["flipped"]
	current_room = agent_data["current_room"]
	path = agent_data["path"]
	waypoint = Map.get_map_node(agent_data["waypoint"])
