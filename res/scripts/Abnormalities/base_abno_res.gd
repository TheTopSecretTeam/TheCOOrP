class_name AbnormalityResource
extends Resource

@export var code: String = "O-00-00"
@export var monster_name: String = "Nothing Here"
@export var texture : Texture2D

@export var threat_level: int = 1
@export var hp : int = 200
@export var max_hp : int = 200

@export var damage_type : String = "physical"
@export var damage_output : int = 5
@export var attack_speed : int = 3 #seconds
@export var travel_speed : int = 5

@export var damage_res_phys : float
@export var damage_res_ment : float

@export var unique_pe : int = 0

@export var actions : Array[AnomalyAction] = []

@export var sold_weapon: WeaponStats
@export var sold_armor: ArmorStats
@export var weapon_cost: Array[int] = [0,0,0,0]
@export var armor_cost: Array[int] = [0,0,0,0]

@export var main_open = false
@export var stats_open = false
@export var armor_open = false
@export var weapon_open = false
@export var actions_open : Array[bool]
@export var mechanics_open : Array[bool]

@export var profile : Texture2D = load("res://UI/research_menu_components/placeholderart.jpg")
@export var mechanics_info : Array[String] = ["WOOOOOOOOOOOOOO", "WEEEEEEEEEEEEE", "WAAAAAAAAAAAAAAAAAaaa"]
@export var lore: String = "Just nothing"

@export var behaviour: GDScript
@export var current_room: NodePath = NodePath()
@export var path2d_progress: float = 0.0

func _ready():
	actions_open.resize(4)
	actions_open.fill(false)
	mechanics_open.resize(mechanics_info.size())
	mechanics_open.fill(false)
