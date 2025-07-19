# GdUnit generated TestSuite
class_name EntityTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TODO make a separate map for the testing

func test_combat() -> void:
	var scene = load("res://scenes/map.tscn").instantiate()
	var runner := scene_runner(scene)
	var chamber = runner.invoke("find_child", "chamber")
	chamber.agent_selected("Pong")
	await await_millis(3000)
	scene.queue_free()

func test_death() -> void:
	var scene = load("res://scenes/map.tscn").instantiate()
	var runner := scene_runner(scene)
	var chamber = runner.invoke("find_child", "chamber")
	var work_manager = runner.invoke("find_child", "WorkSelectManager")
	chamber.show_work()
	work_manager.action(chamber.actions[2])
	chamber.agent_selected("Pong")
	await await_millis(3000)
	scene.queue_free()
	
func test_kill() -> void:
	var scene = load("res://scenes/map.tscn").instantiate()
	var runner := scene_runner(scene)
	var chamber = runner.invoke("find_child", "chamber")
	var work_manager = runner.invoke("find_child", "WorkSelectManager")
	var pong = runner.invoke("find_child", "corridor2")\
					.find_child("room_path").find_child("Agent2")
	pong.entity_resource.current_weapon.base_damage = 200
	chamber.show_work()
	work_manager.action(chamber.actions[2])
	chamber.agent_selected("Pong")
	await await_millis(3000)
	scene.queue_free()
