# GdUnit generated TestSuite
class_name FacilityNavigationTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

func test_get_agent_path() -> void:
	var all_path = [
		[[], [0, 2, 3, 1], [0, 2], [0, 2, 3], [0, 4]],
		[[1, 3, 2, 0], [], [1, 3, 2], [1, 3], [1, 3, 2, 0, 4]],
		[[2, 0], [2, 3, 1], [], [2, 3], [2, 0, 4]],
		[[3, 2, 0], [3, 1], [3, 2], [], [3, 2, 0, 4]],
		[[4, 0], [4, 0, 2, 3, 1], [4, 0, 2], [4, 0, 2, 3], []]
	]
	var runner := scene_runner("res://scenes/map.tscn")
	await runner.simulate_frames(1)
	assert_bool(runner.scene().is_inside_tree()).is_true()
	for start in range(4):
		for end in range(4):
			assert_array(FacilityNavigation.get_agent_path(start, end))\
			.is_equal(all_path[start][end])
