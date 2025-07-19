extends Node

@onready var esc_menu = $"../CanvasLayer/WorkSelectMenu"

var selected_chamber: AnomalyChamber = null
@onready var work_container = $"../CanvasLayer/WorkSelectMenu/Layout/WorkContainer"
@onready var agent_container = $"../CanvasLayer/WorkSelectMenu/Layout/AgentContainer"
var wc_buttons: Array[Button]
@onready var btn = preload("res://UI/styled_button.tscn")
@onready var agent_sprite = preload("res://img/Player.png")
@export var agent_option: PackedScene


func _on_chamber_selected(chamber: AnomalyChamber):
	selected_chamber = chamber
	show_work()

func show_work():
	for work in work_container.get_children():
		work.queue_free()
	for act in selected_chamber.actions:
		var work = btn.instantiate()
		work.set_text(act.action_name)
		work.set_button_icon(act.action_icon)
		for script in act.scripts:
			work.set_script(script)
		work.button_down.connect(_on_work_button_down.bind(act))
		work_container.add_child(work)
	work_container.show()
	agent_container.hide()

func agent_selected(agent_name: String):
	selected_chamber.agent_selected(agent_name)
	work_container.hide()
	agent_container.hide()
	selected_chamber = null

func show_agents():
	for option in agent_container.get_children():
		option.queue_free()
	var avaliable_agents: Array[Agent] = []
	for a in Agents.selected_agents:
		if not a.working:
			avaliable_agents.append(a)
	for a in Agents.agents:
		if not a.working and not a in Agents.selected_agents:
			avaliable_agents.append(a)
	if avaliable_agents.is_empty():
		return
	for a in avaliable_agents:
		var option_inst = agent_option.instantiate()
		option_inst.agent = a.entity_resource
		option_inst.agent_selected.connect(agent_selected)
		agent_container.add_child(option_inst)
	agent_container.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("clickLeftMouse") and (
		agent_container.visible or work_container.visible
	):
		agent_container.call_deferred("hide")
		work_container.call_deferred("hide")
		selected_chamber = null
	
func action(action_res) -> void:
	selected_chamber.anomaly_action = action_res
	show_agents()
func _on_work_button_down(action_res) -> void:
	action(action_res)
