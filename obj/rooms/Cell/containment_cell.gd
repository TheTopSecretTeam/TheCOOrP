extends Room

@export var anomaly : AbnormalityResource 
@onready var unique_pe_counter = $Unique_PE_Counter

func _ready() -> void:
	if anomaly: load_anomaly()
	for child in $room_path.get_children():
		if child is Waypoint:
			if child.leading_room:
				waypoints[child.leading_room.get_index()] = child
				if self.get_index() == 0: print(child.leading_room.get_index())
		if child is Agent:
			agents[child.agent_name] = child
		
func load_anomaly() -> void:
	$AbnoName/Name.text = anomaly.monster_name
	var counter = 1
	return
	for work in anomaly.works:
		if counter >= 4: return
		$CameraArea.stats[counter] = work
		counter+=1
	
func _process(delta: float) -> void:
	unique_pe_counter.text = str(anomaly.unique_pe)
	
func begin_work(probability):
	var progress_bar = $Progress_Bar/Container/Bar
	progress_bar.work(probability)
	

func _on_bar_work_completed(pe_box: Variant) -> void:
	anomaly.unique_pe += pe_box
	unique_pe_counter.text = str(anomaly.unique_pe)

func _on_abno_name_button_down() -> void:
	var research_window_resource = preload("res://obj/rooms/Cell/research_menu_components/research_menu.tscn")
	var research_window_instance = research_window_resource.instantiate()
	$WindowLayer.add_child(research_window_instance)
	research_window_instance.window_call(anomaly)
