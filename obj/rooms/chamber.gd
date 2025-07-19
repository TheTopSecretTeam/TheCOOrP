extends Room
class_name AnomalyChamber

@export var anomaly: AbnormalityResource
@export var bar: AnomalyBar
var anomaly_action: AnomalyAction
#@onready var unique_pe_counter = $Unique_PE_Counter
var wc_buttons: Array[Button]
#@export var stats: Array[Resource] = []
var actions: Array[AnomalyAction] = []
var working: bool = false
var working_agent: Agent
@onready var work_container = $CanvasLayer/CenterContainer/WorkContainer
@export var agent_option: PackedScene
@onready var agent_container = $CanvasLayer/CenterContainer/AgentContainer
@onready var btn = preload("res://UI/styled_button.tscn")

signal agent_kill_requested

func _ready() -> void:
	if anomaly: load_anomaly.rpc()
	work_ready()
	agent_kill_requested.connect(_on_kill_agent_requested)
	super._ready() # Room setup

func transfer(entity: Entity, _previous_room) -> bool:
	if working: return false
	entity.reparent($room_path)
	entity._on_travel()
	entity._on_chamber_arrival()
	
	if entity is Agent:
		entity.progress_ratio = 1.0
		working_agent = entity
		working_agent.working = true
		working = true
		if anomaly_action != null: begin_work.rpc(anomaly_action.resource_path, entity.entity_resource)
	return true

@rpc("any_peer", "call_local")
func load_anomaly() -> void:
	$HBoxContainer/VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"
	$CanvasLayer/ResearchMenu.anomaly = anomaly
	var anomaly_inst = load(anomaly.entity).instantiate()
	$room_path.add_child(anomaly_inst)
	anomaly_inst.flipped = true
	for _action in anomaly.actions:
		print(_action.action_name)
		actions.append(_action)

@rpc("any_peer", "call_local")	
func begin_work(action_str: String, _agent_res):
	var _action = load(action_str) as AnomalyAction
	#make math with player stats and action prob
	bar.work(_action)

func _on_bar_work_completed(pe_box: Variant) -> void:
	working = false
	anomaly.unique_pe += pe_box
	if working_agent != null:
		working_agent.working = false
		working_agent.path = [get_index(), $room_path/waypoint.leading_room.get_index()]
		SyncManager._on_timer_timeout()
		working_agent._on_travel()
		working_agent = null
	$HBoxContainer/VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"

func _on_color_rect_pressed() -> void:
	show_work()
	
func show_work() -> void:
	if working:
		return
	work_container.visible = not work_container.visible
	agent_container.hide()


func agent_selected(agent_name: String):
	Agents.send_agent.emit(agent_name, get_index())
	agent_container.hide()

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
	#$AgentContainer.global_position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("clickLeftMouse") and (
		agent_container.visible
	):
		agent_container.call_deferred("hide")
		working = false

func escape():
	if get_node_or_null(^"room_path/Anomaly") == null:
		return
	$Label.show()
	$EscapeTimer.start()
	$EscapeTimer.started = true

func _on_escape_timer_timeout() -> void:
	on_escape_timer_timeout.rpc()

@rpc("any_peer", "call_local")
func on_escape_timer_timeout() -> void:
	$Label.hide()
	$EscapeTimer.started = false
	$room_path/Anomaly.path = [get_index(), $room_path/waypoint.leading_room.get_index()]
	$room_path/Anomaly._on_travel()

func _on_abno_name_button_down() -> void:
	$CanvasLayer/ResearchMenu.window_call(anomaly)
	#research_window_instance.window_call(anomaly)

func _on_work_button_down(action_res) -> void:
	action(action_res)

func action(action_res) -> void:
	if working: return
	anomaly_action = action_res
	work_container.hide()
	show_agents()

func work_ready():
	for act in actions:
		var work = btn.instantiate()
		work.set_text(act.action_name)
		work.set_button_icon(act.action_icon)
		for script in act.scripts:
			work.set_script(script)
		work.button_down.connect(_on_work_button_down.bind(act))
		work_container.add_child(work)


# NET
func get_sync_data() -> Dictionary:
	var agent_id = ""
	if working_agent:
		agent_id = working_agent.entity_resource.agent_name
	return {
		"working": working,
		"working_agent_id": agent_id,
		"waiting_time": $EscapeTimer.wait_time,
		"remaining_time": $EscapeTimer.get_time_left()
	}

func apply_sync_data(data: Dictionary) -> void:
	var remaining_time = data["remaining_time"]
	var waiting_time = data["waiting_time"]
	
	if !$EscapeTimer.started and remaining_time != 0:
		$EscapeTimer.wait_time = waiting_time
		$Label.show()
		$EscapeTimer.start(remaining_time)
		$EscapeTimer.started = true
	if remaining_time == 0:
		$Label.hide()
		$EscapeTimer.stop()
		$EscapeTimer.started = false
		
	working = data["working"]
	if data["working_agent_id"]:
		for agent in Agents.agents:
			if agent.entity_resource.agent_name == data["working_agent_id"]:
				working_agent = agent
				break
	else:
		working_agent = null
		

func _on_kill_agent_requested():
	if working_agent and working:
		bar.drop_work.emit()
		working_agent.die()
