class_name AbnormalityResource
extends Resource

@export var code: String = "O-00-00"
@export var monster_name: String = "Nothing Here"
@export_multiline var description: String = ""
@export var threat_level: int = 1
@export var hp : int = 200
@export var max_hp : int = 200
@export var damage_type : String = "physical"
@export var damage_output : int = 5
@export var attack_speed : int = 3 #seconds
@export var travel_speed : int = 5
@export var texture : Texture2D

@export var unique_pe : int = 0

@export var damage_res_phys : float = 1
@export var damage_res_ment : float = 2

@export var actions : Array[AnomalyAction] = []
@export var actions_open : Array[bool] = []
@export var actions_cost : Array[int] = []

@export var behaviour: GDScript

@export var current_room: NodePath = NodePath()
@export var path2d_progress: float = 0.0

@export var sold_weapon: WeaponStats
@export var sold_armor: ArmorStats
@export var weapon_cost: Array[int] = [0,0,0,0]
@export var armor_cost: Array[int] = [0,0,0,0]
var armor_open = false
var weapon_open = false
@export_multiline var mechanics_info : Array[String] = ["WOOOOOOOOOOOOOO", "WEEEEEEEEEEEEE", "WAAAAAAAAAAAAAAAAAaaa"]
@export_multiline var lore: String = "Just nothing"
