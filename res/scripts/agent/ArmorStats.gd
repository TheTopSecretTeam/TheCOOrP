extends Resource
class_name ArmorStats

@export var name: String = "Basic Armor"
@export var physical_resistance: float = 1
@export var mental_resistance: float = 1
@export var sprite: Texture2D = null
@export var special_effects_text: String

@export var effects: Array[GDScript] = []
