extends Room
class_name AnomalyChamber

@export var anomaly : AbnormalityResource 
#@onready var unique_pe_counter = $Unique_PE_Counter
var wc_buttons : Array[Button]
@export var stats: Array[Resource] = []
@export var actions : Array[AnomalyAction] = []
var working : bool = false
var work_probability : float
var working_agent : Agent
@onready var work_container = $CanvasLayer/CenterContainer/WorkContainer
@export var agent_option : PackedScene
@onready var btn = preload("res://UI/styled_button.tscn")

func _ready() -> void:
	if anomaly: load_anomaly()
	work_ready()
	for child in $room_path.get_children():
		if child is Waypoint:
			if child.leading_room:
				waypoints[child.leading_room.get_index()] = child
				#if self.get_index() == 0: print(child.leading_room.get_index())

func transfer(entity: Entity, _previous_room):
	entity.reparent($room_path)
	entity._on_travel()
	entity._on_chamber_arrival()
	
	if entity is Agent:
		entity.progress_ratio = 1.0
		working_agent = entity
		working_agent.working = true
		begin_work(work_probability, entity.entity_resource)

func load_anomaly() -> void:
	$HBoxContainer/VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"
	$CanvasLayer/ResearchMenu.anomaly = anomaly
	for _action in anomaly.actions:
		actions.append(_action)
#func _process(delta: float) -> void:      #THIS IS BAD
	#unique_pe_counter.text = str(anomaly.unique_pe)
func begin_work(probability, _agent_res):
	#make math with player stats and action prob
	$Bar.work(probability)

func _on_bar_work_completed(pe_box: Variant) -> void:
	working_agent.working = false
	working = false
	anomaly.unique_pe += pe_box
	escape()
	working_agent.path = [get_index(),$room_path/waypoint.leading_room.get_index()]
	working_agent._on_travel()
	working_agent = null
	$HBoxContainer/VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"

func _on_color_rect_pressed() -> void:
	show_work()
	
func show_work() -> bool:
	if working:
		return false
	else:
		if !work_container.visible:
			work_container.show()
		else:
			work_container.hide()
		#work_container.global_position = get_global_mouse_position()
		return true

func agent_selected(agent_name : String):
	Global.send_agent.emit(agent_name, get_index())
	$CanvasLayer/CenterContainer/AgentContainer.hide()

func show_agents():
	for option in $CanvasLayer/CenterContainer/AgentContainer.get_children():
		option.queue_free()
	for agent in Global.agents:
		var option_inst = agent_option.instantiate()
		option_inst.agent = agent.entity_resource
		option_inst.agent_selected.connect(agent_selected)
		$CanvasLayer/CenterContainer/AgentContainer.add_child(option_inst)
	$CanvasLayer/CenterContainer/AgentContainer.show()
	#$AgentContainer.global_position = get_global_mouse_position()

func escape():
	if get_node_or_null(^"room_path/Anomaly") == null:
		return
	$Label.show()
	$EscapeTimer.start()
	$EscapeTimer.started = true

func _on_escape_timer_timeout() -> void:
	$Label.hide()
	$EscapeTimer.started = false
	$room_path/Anomaly.path = [get_index(),$room_path/waypoint.leading_room.get_index()]
	$room_path/Anomaly._on_travel()

func _on_abno_name_button_down() -> void:
	$CanvasLayer/ResearchMenu.window_call(anomaly)
	#research_window_instance.window_call(anomaly)

func _on_work_button_down(action_res) -> void:
	action(action_res)

func action(action_res) -> String:
	if working: return "ALREADY_WORKING"
	working = true
	work_probability = action_res.probability
	work_container.hide()
	show_agents()
	return "SUCCESS"

func work_ready():
	for _action in actions:
		var work = btn.instantiate()
		work.set_text(_action.action_name)
		work.set_button_icon(_action.action_icon)
		for script in _action.scripts:
			work.set_script(script)
		work.button_down.connect(_on_work_button_down.bind(_action))
		work_container.add_child(work)
