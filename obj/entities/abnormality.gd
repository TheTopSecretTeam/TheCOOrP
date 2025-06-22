extends PathFollow2D

@export var abno_res: AbnormalityResource
@export var behavior_instance: GDScript

var monster_name: String
var threat_level: int
var hp : int
var max_hp : int
var damage_type : String
var damage_output : int
var attack_speed : int
var travel_speed : int
var texture : Texture2D
var works : Array[Work]
var behaviour: GDScript
var mechanics_info : Array[String]
var lore: String
var current_room: NodePath
var path2d_progress: float
var sold_weapon: WeaponStats
var sold_armor: ArmorStats
var weapon_cost: int
var armor_cosr: int

func _import_resource_stats():
	if !abno_res:
		push_error("No resource assigned to monster")
		return
	
	# Imports all exported variables
	for property in abno_res.get_property_list():
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var prop_name = property.name
			if prop_name in self:  # Only copies existing properties
				self[prop_name] = abno_res.get(prop_name)

signal set_behaviour(new_behavior: GDScript)

func _init():
	set_behaviour.connect(_set_behaviour)

func _ready():
	_import_resource_stats()
	if abno_res and abno_res.behaviour:
		# Creates and attaches behavior
		behavior_instance = abno_res.behaviour.new()
		behavior_instance.abno = self
		behavior_instance._ready()
		

func _process(delta):
	if behavior_instance:
		behavior_instance._process(delta)
		
func _set_behaviour(new_behavior: GDScript):
	if behavior_instance and behavior_instance.is_processing():
		behavior_instance.set_process(false)
		behavior_instance.queue_free()
		behavior_instance = new_behavior.new()
		behavior_instance.abno = self
		behavior_instance._ready()
