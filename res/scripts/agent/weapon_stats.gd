extends Resource
class_name WeaponStats

@export var name: String = "Basic Weapon"
@export var base_damage: int = 10
@export var damage_type: String = "physical"
@export var attack_speed: int = 10
@export var weapon_range: int = 10
@export var sprite: Texture2D = null

@export var effects: Array[GDScript] = []
