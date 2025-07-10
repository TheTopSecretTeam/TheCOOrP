# entity.gd
class_name Entity
extends PathFollow2D

# Reference to the entity's resource data
@export var entity_resource: EntityResource
var path: Array = []
var target: Entity = null
var attack_cooldown: float = 0.0
@export var current_room_path: Path2D
var current_room: int
var waypoint: Node2D

@export var flipped: bool = false:
	set(value):
		if value:
			$Skeleton.scale.x = -0.5
			entity_resource.travel_speed = -1 * abs(entity_resource.travel_speed)
		else:
			$Skeleton.scale.x = 0.5
			entity_resource.travel_speed = abs(entity_resource.travel_speed)
		flipped = value

func _ready() -> void:
	if entity_resource:
		entity_resource.current_room = get_path_to(get_parent())
	if get_parent() is Path2D:
		current_room_path = get_parent()
		print("X")

func _process(delta: float) -> void:
	if attack_cooldown > 0:
		attack_cooldown -= delta
	if entity_resource.is_alive():
		handle_combat(delta)

func flip():
	flipped = !flipped

func _on_chamber_arrival():
	pass

func _on_travel():
	pass

func handle_combat(delta: float) -> void:
	if not target or not target.entity_resource.is_alive() or target.current_room != current_room:
		target = find_target()
		if not target:
			return
	
	var distance = global_position.distance_to(target.global_position)
	
	if distance <= entity_resource.get_attack_range():
		if attack_cooldown <= 0:
			entity_resource.attack(target)
			print(str(target.entity_resource.current_hp), str(target.entity_resource.is_alive()))
			if !target.entity_resource.is_alive(): target.die()
			attack_cooldown = 1.0 / entity_resource.get_attack_speed()
	else:
		move_toward_target(delta)

func move_toward_target(delta: float) -> void:
	if not target or not current_room_path:
		return
	
	var target_progress = target.progress
	var direction = sign(target_progress - progress)
	flipped = direction == -1
	print($Skeleton.scale, scale, entity_resource.travel_speed, name)
	progress += entity_resource.travel_speed * delta

func find_target() -> Entity:
	var potential_targets = []
	var room = get_parent()
	
	# Get all entities in the same room that are on different teams
	for child in room.get_children():
		if child is Entity and child != self:
			if child.entity_resource.team != entity_resource.team:
				potential_targets.append(child)
	
	# Find the closest target
	if not potential_targets.is_empty():
		potential_targets.sort_custom(func(a, b):
			return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
		)
		return potential_targets[0]
	
	return null

func take_damage(amount: int, type: String) -> void:
	entity_resource.take_damage(amount, type)
	print("HIT")
	if not entity_resource.is_alive():
		print("DED")
		die()

func die() -> void:
	queue_free()

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
