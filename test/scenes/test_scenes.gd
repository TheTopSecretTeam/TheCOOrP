# GdUnit generated TestSuite
class_name TestScenes
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/main_menu.gd'

## Scene Unit Test
## Tests for compilation, instantiation, and simulation of a single frame.

const SCENES := [
	"res://scenes/main_menu.tscn",
	"res://scenes/map.tscn",
]

## Scene compiles & instantiates without runtime errors
func test_scene_compiles() -> void:
	for scene in SCENES:
		await assert_error(func (): load(scene)\
				.instantiate()\
				.free()\
				).is_success()


## Enters the tree and survives one frame
func test_scene_starts(timeout = 5000) -> void:
	for scene in SCENES:
		var runner := scene_runner(scene)
		await runner.simulate_frames(1)
		assert_bool(runner.scene().is_inside_tree()).is_true()
