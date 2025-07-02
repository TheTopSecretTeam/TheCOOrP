# agent_stats.gd
extends EntityResource

class_name AgentStats

@export var agent_name: String = "PingPong"
@export var max_sp: int = 50
@export var current_sp: int = 50

# Equipment references
@export var current_armor: ArmorStats = null
@export var current_weapon: WeaponStats = null

func get_resistance(damage_type: String) -> float:
	if current_armor:
		match damage_type:
			"physical":
				return current_armor.physical_resistance
			"mental":
				return current_armor.mental_resistance
	# Default to no armor
	return 1.0

func get_damage_output() -> int:
	if current_weapon:
		return current_weapon.base_damage
	return 0  # Can't attack without weapon

func get_damage_type() -> String:
	if current_weapon:
		return current_weapon.damage_type
	return "physical"  # Default damage type

func get_attack_speed() -> float:
	if current_weapon:
		return 1.0 / current_weapon.attack_speed
	return 1.0  # Default attack speed

func get_attack_range() -> int:
	if current_weapon:
		return current_weapon.weapon_range
	return 0  # Can't attack without weapon
