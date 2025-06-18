extends Resource
class_name AgentStats

@export var name: String = "Bong Bong"
@export var max_hp: int = 100
@export var current_hp: int = 100
@export var max_sp: int = 50
@export var current_sp: int = 50

#const ArmorStats = preload("res://resources/agent_resources/ArmorStats.gd")
#const WeaponStats = preload("res://resources/agent_resources/WeaponStats.gd")
@export var current_armor: ArmorStats = null
@export var current_weapon: WeaponStats = null

@export var current_room: NodePath = NodePath()
@export var path2d_progress: float = 0.0
