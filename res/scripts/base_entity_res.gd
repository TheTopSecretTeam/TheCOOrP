# entity_resource.gd
class_name EntityResource
extends Resource

@export var display_name: String = "Entity"
@export var current_room: NodePath = NodePath()
@export var path2d_progress: float = 0.0
@export var team: int = 0

@export var max_hp: int = 100
@export var current_hp: int = 100
@export var travel_speed: int = 5

@export var base_damage_output: int = 5
@export var base_attack_speed: float = 3.0 # seconds between attacks
@export var base_damage_type: String = "physical"
@export var base_damage_res_phys: float = 1.0 # Resistance as multiplier (1.0 = normal damage)
@export var base_damage_res_ment: float = 1.0
@export var attack_range: int = 10

func get_resistance(damage_type: String) -> float:
	match damage_type:
		"physical":
			return base_damage_res_phys
		"mental":
			return base_damage_res_ment
		_:
			return 1.0
			
func get_attack_range() -> int:
	return attack_range

func get_damage_output() -> int:
	return base_damage_output

func get_damage_type() -> String:
	return base_damage_type

func get_attack_speed() -> float:
	return 1.0 / base_attack_speed

func is_alive() -> bool:
	return current_hp > 0
	
	
func take_damage(amount: int, type: String) -> void:
	var resistance = get_resistance(type)
	var final_damage = amount * resistance
	
	current_hp -= int(final_damage)
	current_hp = max(current_hp, 0)
	
	
func attack(target: Entity) -> void:
	if not target or not is_alive() or not target.entity_resource.is_alive():
		return
	
	var base_damage = get_damage_output()
	var damage_type = get_damage_type()
	target.entity_resource.take_damage(base_damage, damage_type)
