extends VBoxContainer

@onready var resource_textures = {
	"Materials": preload("res://UI/resource-display/materials.png"),
	"Funds": preload("res://UI/resource-display/funds.png"),
	"Radiance": preload("res://UI/resource-display/radiance.png"),
	"Blight": preload("res://UI/resource-display/blight.png")
}

func _ready():
	$ResourseSlot/TextureRect.texture = resource_textures["Materials"]
	$ResourseSlot2/TextureRect.texture = resource_textures["Funds"]
	$ResourseSlot3/TextureRect.texture = resource_textures["Radiance"]
	$ResourseSlot4/TextureRect.texture = resource_textures["Blight"]
	
	Global.resources_changed.connect(update_resources)
	update_resources(Global.resources)

func update_resources(new_resources):
	$ResourseSlot/Label.text = str(new_resources["Materials"])
	$ResourseSlot2/Label.text = str(new_resources["Funds"])
	$ResourseSlot3/Label.text = str(new_resources["Radiance"])
	$ResourseSlot4/Label.text = str(new_resources["Blight"])
