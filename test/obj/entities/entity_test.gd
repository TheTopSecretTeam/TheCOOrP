# GdUnit generated TestSuite
class_name EntityTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

func test_combat() -> void:
	var scene = load("res://scenes/map.tscn").instantiate()
	var runner := scene_runner(scene)
	var chamber = runner.invoke("find_child", "chamber")
	chamber.agent_selected("Pong")
	await await_millis(60000)
	scene.queue_free()

func test_death() -> void:
	var scene = load("res://scenes/map.tscn").instantiate()
	var runner := scene_runner(scene)
	var chamber = runner.invoke("find_child", "chamber")
	var pong = runner.invoke("find_child", "corridor2")\
					.find_child("room_path").find_child("Agent2")
	chamber.action(chamber.actions[2])
	chamber.agent_selected("Pong")
	await await_millis(60000)
	scene.queue_free()
	
func test_kill() -> void:
	var scene = load("res://scenes/map.tscn").instantiate()
	var runner := scene_runner(scene)
	var chamber = runner.invoke("find_child", "chamber")
	var pong = runner.invoke("find_child", "corridor2")\
					.find_child("room_path").find_child("Agent2")
	pong.entity_resource.current_weapon.base_damage = 200
	chamber.action(chamber.actions[2])
	chamber.agent_selected("Pong")
	await await_millis(60000)
	scene.queue_free()
