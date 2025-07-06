# GdUnit generated TestSuite
class_name FacilityNavigationTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/facility_navigation.gd'


func test_get_agent_path() -> void:
	var all_path = [
		[[], [0, 2, 3, 1], [0, 2], [0, 2, 3], [0, 4]],
		[[1, 3, 2, 0], [], [1, 3, 2], [1, 3], [1, 3, 2, 0, 4]],
		[[2, 0], [2, 3, 1], [], [2, 3], [2, 0, 4]],
		[[3, 2, 0], [3, 1], [3, 2], [], [3, 2, 0, 4]],
		[[4, 0], [4, 0, 2, 3, 1], [4, 0, 2], [4, 0, 2, 3], []]
	]
	var pathfinder = preload(__source).new()
	for start in range(4):
		for end in range(4):
			assert_array(pathfinder.get_agent_path(start, end))\
			.is_equal(all_path[start][end])
	pathfinder.queue_free()
