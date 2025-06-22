extends Room

@export var anomaly : AbnormalityResource 
#@onready var unique_pe_counter = $Unique_PE_Counter
var wc_buttons : Array[Button]
@export var stats: Array[Resource] = [null, null, null, null]
var working
@onready var work_container = $CanvasLayer/WorkContainer

func _ready() -> void:
	if anomaly: load_anomaly()
	for child in $room_path.get_children():
		if child is Waypoint:
			if child.leading_room:
				waypoints[child.leading_room.get_index()] = child
				#if self.get_index() == 0: print(child.leading_room.get_index())

func transfer(agent: Agent, _previous_room):
	agent.reparent($CharacterMarker)
	agent.position = Vector2.ZERO
	agent._on_travel()
	agent.state = 2

func load_anomaly() -> void:
	$HBoxContainer/VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"
	$CanvasLayer/ResearchMenu.anomaly = anomaly
	#var counter = 1
	#for work in anomaly.works:
		#if counter >= 4: return
		#$CameraArea.stats[counter] = work
		#counter+=1
#func _process(delta: float) -> void:      #THIS IS BAD
	#unique_pe_counter.text = str(anomaly.unique_pe)
func begin_work(probability):
	var progress_bar = $Progress_Bar/Container/Bar
	progress_bar.work(probability)

func _on_bar_work_completed(pe_box: Variant) -> void:
	working = false
	anomaly.unique_pe += pe_box
	$VBoxContainer/LinkButton.text = anomaly.monster_name + " (" + str(anomaly.unique_pe) + ")"

func show_work():
	work_container.show()
	work_container.global_position = get_global_mouse_position()

func _on_abno_name_button_down() -> void:
	$CanvasLayer/ResearchMenu.show()
	#research_window_instance.window_call(anomaly)

func _on_work_button_down() -> void:
	working = true
	work_container.hide()
	

func work_ready():
	set_process_unhandled_input(true)
	work_container.hide()
	for i in stats.size():
		var work = Button.new()
		work_container.add_child(work)
		wc_buttons.append(work)
		wc_buttons[i].set_text(stats[i].button_text)
		wc_buttons[i].set_button_icon(stats[i].icon)
		wc_buttons[i].set_script(stats[i].scripts[0])
		wc_buttons[i].button_down.connect(wc_buttons[i]._on_work_button_down)
		wc_buttons[i].button_down.connect(_on_work_button_down)
