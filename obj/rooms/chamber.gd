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
	if anomaly: load_anomaly.rpc()
	work_ready()
	for child in $room_path.get_children():
		if child is Waypoint:
			if child.leading_room:
				waypoints[child.leading_room.get_index()] = child
				#if self.get_index() == 0: print(child.leading_room.get_index())

func transfer(agent: Agent, _previous_room):
	agent.reparent($room_path)
	agent.progress_ratio = 1.0
	agent._on_travel()
	agent._on_chamber_arrival()
	working_agent = agent
	# net sync
	begin_work.rpc(work_probability, agent.agent_res)

@rpc("any_peer", "call_local")
func load_anomaly() -> void:
	$HBoxContainer/VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"
	$CanvasLayer/ResearchMenu.anomaly = anomaly
	for action in anomaly.actions:
		actions.append(action)
#func _process(delta: float) -> void:      #THIS IS BAD
	#unique_pe_counter.text = str(anomaly.unique_pe)

@rpc("any_peer", "call_local")		
func begin_work(probability, _agent_res):
	#make math with player stats and action prob
	$Bar.work(probability)

func _on_bar_work_completed(pe_box: Variant) -> void:
	working = false
	anomaly.unique_pe += pe_box

	if working_agent and is_instance_valid(working_agent):  # Дополнительная проверка
		if $room_path/waypoint and $room_path/waypoint.leading_room:
			working_agent.path = [get_index(), $room_path/waypoint.leading_room.get_index()]
			working_agent._on_travel()
	working_agent = null  # Очищаем ссылку

	$HBoxContainer/VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"
	
	
# show menu with options of work, and hide them when click again
func show_work():
	if !work_container.visible:
		work_container.show()
	else:
		work_container.hide()
	#work_container.global_position = get_global_mouse_position()

func agent_selected(agent_name : String):
	Global.send_agent.emit(agent_name, get_index())
	$CanvasLayer/CenterContainer/AgentContainer.hide()

func show_agents():
	for option in $CanvasLayer/CenterContainer/AgentContainer.get_children():
		option.queue_free()
	for agent in Global.agents:
		var option_inst = agent_option.instantiate()
		option_inst.agent = agent.agent_res
		option_inst.agent_selected.connect(agent_selected)
		$CanvasLayer/CenterContainer/AgentContainer.add_child(option_inst)
	$CanvasLayer/CenterContainer/AgentContainer.show()
	#$AgentContainer.global_position = get_global_mouse_position()
	

func _on_abno_name_button_down() -> void:
	$CanvasLayer/ResearchMenu.window_call(anomaly)
	#research_window_instance.window_call(anomaly)

func _on_work_button_down(action_res) -> void:
	working = true
	work_probability = action_res.probability
	work_container.hide()
	show_agents()

# it's simply responsible for the menu popping up with a choice of work
func work_ready():
	for action in actions:
		var work = btn.instantiate()
		work.set_text(action.action_name)
		work.set_button_icon(action.action_icon)
		for script in action.scripts:
			work.set_script(script)
		work.button_down.connect(_on_work_button_down.bind(action))
		work_container.add_child(work)

# used when mouse click on anomaly cell
func _on_color_rect_pressed() -> void:
	show_work()

# NET
func get_sync_data() -> Dictionary:
	var agent_id = ""
	if working_agent and is_instance_valid(working_agent) and working_agent.has_node("Name"):
		agent_id = working_agent.get_node("Name").text
	return {
		"working": working,
		"work_probability": work_probability,
		"working_agent_id": agent_id
	}

func apply_sync_data(data: Dictionary) -> void:
	working = data["working"]
	work_probability = data["work_probability"]
	
	# Ищем агента по тексту из его ноды Name
	if data["working_agent_id"]:
		for agent in get_tree().get_nodes_in_group("agents"):
			if agent.has_node("Name") and agent.get_node("Name").text == data["working_agent_id"]:
				working_agent = agent
				break
	else:
		working_agent = null
