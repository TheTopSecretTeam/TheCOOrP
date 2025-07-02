class_name AbnormalityResource
extends EntityResource

@export var code: String = "O-00-00"
@export var monster_name: String = "Nothing Here"
@export var threat_level: int = 1
@export var unique_pe: int = 0

@export var actions: Array[AnomalyAction] = []
@export var actions_open: Array[bool] = []
@export var actions_cost: Array[int] = []

@export var behaviour: GDScript
@export var sold_weapon: WeaponStats
@export var sold_armor: ArmorStats
@export var weapon_cost: Array[int] = [0,0,0,0]
@export var armor_cost: Array[int] = [0,0,0,0]

var armor_open = false
var weapon_open = false

@export var profile: Texture2D = load("res://UI/research_menu_components/placeholderart.jpg")
@export var mechanics_info: Array[String] = ["Info1", "Info2", "Info3"]
@export var lore: String = "Just nothing"
