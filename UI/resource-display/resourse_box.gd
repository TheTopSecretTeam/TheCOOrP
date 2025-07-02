extends VBoxContainer

func _ready():
	Global.resources_changed.connect(update_resources)
	update_resources(Global.resources)

func update_resources(new_resources):
	$ResourseSlot/Label.text = str(new_resources["Materials"])
	$ResourseSlot2/Label.text = str(new_resources["Funds"])
	$ResourseSlot3/Label.text = str(new_resources["Radiance"])
	$ResourseSlot4/Label.text = str(new_resources["Blight"])
