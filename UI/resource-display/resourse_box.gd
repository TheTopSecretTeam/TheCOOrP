extends VBoxContainer

var resources = {
	"ma": {"texture": preload("res://UI/resource-display/materials.png"), "count": 0},
	"fu": {"texture": preload("res://UI/resource-display/funds.png"), "count": 0},
	"ra": {"texture": preload("res://UI/resource-display/radiance.png"), "count": 0},
	"bl": {"texture": preload("res://UI/resource-display/blight.png"), "count": 0}
}

@onready var slots = self.get_children()

func _ready():
	update_all_resources()

func update_all_resources():
	$ResourseSlot/TextureRect.texture = resources.ma.texture
	$ResourseSlot/Label.text = "0"
	$ResourseSlot2/TextureRect.texture = resources.fu.texture
	$ResourseSlot2/Label.text = "0"
	$ResourseSlot3/TextureRect.texture = resources.ra.texture
	$ResourseSlot3/Label.text = "0"
	$ResourseSlot4/TextureRect.texture = resources.bl.texture
	$ResourseSlot4/Label.text = "0"
