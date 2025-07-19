extends Room
class_name AnomalyChamber

@export var anomaly: AbnormalityResource
@export var bar: AnomalyBar
var anomaly_action: AnomalyAction
var actions: Array[AnomalyAction] = []
var working: bool = false
var working_agent: Agent

signal chamber_selected

func _ready() -> void:
	if anomaly: load_anomaly()
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
		begin_work(anomaly_action, entity.entity_resource)
	return true

func load_anomaly() -> void:
	$HBoxContainer/VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"
	$CanvasLayer/ResearchMenu.anomaly = anomaly
	var anomaly_inst = load(anomaly.entity).instantiate()
	$room_path.add_child(anomaly_inst)
	anomaly_inst.flipped = true
	for _action in anomaly.actions:
		print(_action.action_name)
		actions.append(_action)

func agent_selected(agent_name: String):
	Agents.send_agent.emit(agent_name, get_index())

func begin_work(_action: AnomalyAction, _agent_res):
	#make math with player stats and action prob
	bar.work(_action)

func _on_bar_work_completed(pe_box: Variant) -> void:
	working_agent.working = false
	working = false
	anomaly.unique_pe += pe_box
	working_agent.path = [get_index(), $room_path/waypoint.leading_room.get_index()]
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
	$Label.hide()
	$EscapeTimer.started = false
	$room_path/Anomaly.path = [get_index(), $room_path/waypoint.leading_room.get_index()]
	$room_path/Anomaly._on_travel()

func _on_abno_name_button_down() -> void:
	$CanvasLayer/ResearchMenu.window_call(anomaly)
	#research_window_instance.window_call(anomaly)
