class_name AbnormalityResource
extends Resource

@export var monster_name: String = "Nothing Here"
@export var threat_level: int = 1
@export var hp : int = 200
@export var damage_type : String = "physical"
@export var damage_output : int = 5
@export var attack_speed : int = 3 #seconds
@export var travel_speed : int = 5
@export var texture : Texture2D

@export var works : Array[Work] = []

@export var behaviour: GDScript

@export var mechanics_info : Array[String] = []
@export var lore: String = "Just nothing"
