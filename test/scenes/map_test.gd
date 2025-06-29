# GdUnit generated TestSuite
class_name MapTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/map.tscn'

func test_send_agent() -> void:
	var agents = {
		"Anna" : [true, 0],
		"Brad" : [true, 1],
		"Jake" : [false, null],
		"Charles" : [false, null]
	}
	var object = load(__source).instantiate()
	object._ready()
	var result
	for room in 4:
		for agent in agents.keys():
			result = object.send_agent(agent, room)
			if !agents[agent][0]:
				assert_str(result).is_equal("agent_not_found")
			else:
				if room == agents[agent][1]:
					assert_str(result).is_equal('success stand')
				else:
					assert_str(result).is_equal("success move")
