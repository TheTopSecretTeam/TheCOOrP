extends Button

@export var inventory : Control

func _on_pressed() -> void:
	var agent_res = Agents.agents.map(
		func(thing):
			print(thing)
			return thing.entity_resource
			)
	var typed : Array[AgentStats] = []
	typed.assign(agent_res)
	inventory.window_call(typed,
	Agents.armor,Agents.weapons)
