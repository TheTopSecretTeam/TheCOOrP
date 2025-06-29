# GdUnit generated TestSuite
class_name FacilityNavigationTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/facility_navigation.gd'


func test_get_agent_path() -> void:
	var test_path = {
		0: {0: [], 1: [0, 2, 3, 1], 2: [0, 2], 3: [0, 2, 3], 4: [0, 4]},
		1: {0: [1, 3, 2, 0], 1: [], 2: [1, 3, 2], 3: [1, 3], 4: [1, 3, 2, 0, 4]},
		2: {0: [2, 0], 1: [2, 3, 1], 2: [], 3: [2, 3], 4: [2, 0, 4]},
		3: {0: [3, 2, 0], 1: [3, 1], 2: [3, 2], 3: [], 4: [3, 2, 0, 4]},
		4: {0: [4, 0], 1: [4, 0, 2, 3, 1], 2: [4, 0, 2], 3: [4, 0, 2, 3], 4: []}
	}
	var object = load(__source).new()
	for i in 4:
		for j in 4:
			assert_array(object.get_agent_path(i, j)).is_equal(test_path[i][j])
			if is_failure():
				return
