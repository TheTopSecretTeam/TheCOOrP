# GdUnit generated TestSuite
class_name AnomalyChamberTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://obj/rooms/chamber.tscn'


func test_show_work() -> void:
	var chamber = preload(__source).instantiate()
	chamber.show_work()
	assert_bool(chamber.show_work()).is_equal(false)
	if is_failure(): return


func test_action() -> void:
	var chamber = preload(__source).instantiate()
	var test_work = AnomalyAction.new()
	chamber.action(test_work)
	assert_bool(chamber.action(test_work)).is_equal(false)
	if is_failure(): return
