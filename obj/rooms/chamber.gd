extends Room
class_name AnomalyChamber

@export var anomaly: AbnormalityResource
@export var bar: AnomalyBar
var anomaly_action: AnomalyAction
var actions: Array[AnomalyAction] = []
var working: bool = false
var working_agent: Agent

signal chamber_selected

signal agent_kill_requested

func _ready() -> void:
	if anomaly: load_anomaly.rpc()
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
	#var anomaly_inst = load(anomaly.entity).instantiate()
	#$room_path.add_child(anomaly_inst)
	#anomaly_inst.flipped = true
	for _action in anomaly.actions:
		print(_action.action_name)
		actions.append(_action)

func agent_selected(agent_name: String):
	Agents.send_agent.emit(agent_name, get_index())

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
	chamber_selected.emit(self)

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


# NET
func get_sync_data() -> Dictionary:
	var agent_id = ""
	if working_agent:
		agent_id = working_agent.entity_resource.agent_name
	return {
		"working": working,
		"working_agent_id": agent_id,
		"waiting_time": $EscapeTimer.wait_time,
		"remaining_time": $EscapeTimer.get_time_left(),
		"visible": visible
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
	visible = data["visible"]
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
