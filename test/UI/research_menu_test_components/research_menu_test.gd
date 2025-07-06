# GdUnit generated TestSuite
class_name ResearchMenuTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://UI/research_menu_components/research_menu.gd'


func test__on_buy_armor_button_down() -> void:
	var scene = load("res://scenes/map.tscn").instantiate()
	var runner := scene_runner(scene)
	var research_menu = runner.invoke("find_child", "chamber")\
						.find_child("CanvasLayer").find_child("ResearchMenu")
	research_menu._on_buy_armor_button_down()
	var test_resources : Dictionary[String, int] = {
	"Materials" : 5,
	"Funds" : 9, 
	"Radiance" : 12, 
	"Blight" : 12,
	}
	for resource in test_resources.keys():
		assert_bool(test_resources[resource]==Global.resources[resource]).is_true()
	assert_dict(Global.resources).is_equal(test_resources)
	scene.queue_free()
