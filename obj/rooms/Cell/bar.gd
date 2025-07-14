extends Sprite2D
class_name AnomalyBar

signal work_completed(pe_box)
signal drop_work

@export var chamber: AnomalyChamber

var should_drop_work : bool = false

var MAX = 10
var PROB = 0.6
var TIME = 1

var anomaly_action: AnomalyAction
var pe_list: Array[TextureRect]
var ne_list: Array[TextureRect]

var pe = 0
var ne = 0
var is_working = false

var rng = RandomNumberGenerator.new()
@onready var pe_list_parent = $PE_list
@onready var ne_list_parent = $NE_list
@onready var timer = $Timer

func _ready() -> void:
	rng.seed = Global.Seed
	drop_work.connect(_on_drop_work)
	for child in pe_list_parent.get_children():
		pe_list.append(child)
		pe_list[-1].visible = false
	for child in ne_list_parent.get_children():
		ne_list.append(child)
		ne_list[-1].visible = false
	print("AnomalyBar: Initialized for ", name)

func start_work(action: AnomalyAction) -> void:
	if is_working:
		print("AnomalyBar: Already working, ignoring start_work")
		return
	if not multiplayer.is_server():
		return
	anomaly_action = action
	PROB = action.probability
	pe = 0
	ne = 0
	is_working = true
	for tex in pe_list:
		tex.visible = false
	for tex in ne_list:
		tex.visible = false
	timer.wait_time = TIME
	timer.start()
	print("AnomalyBar: Work started, action: ", action.action_name)

func work(action: AnomalyAction) -> void:
	if multiplayer.is_server():
		start_work(action)

@rpc("any_peer", "call_local")
func _on_bar_work_completed(pe_box: Variant) -> void:
	work_completed.emit(pe_box)


func _on_timer_timeout():
	if not multiplayer.is_server():
		return
	if should_drop_work:
		should_drop_work = false
		timer.stop()
		_on_bar_work_completed(pe)
		return
	if ne + pe < MAX:
		generate_cell(PROB)
	else:
		is_working = false
		timer.stop()
		_on_bar_work_completed.rpc(pe)
		should_drop_work = false
		print("AnomalyBar: Work completed, pe: ", pe)

func generate_cell(prob: float) -> void:
	if not multiplayer.is_server():
		return
	var success = [true, false]
	var weights = PackedFloat32Array([prob, 1 - prob])
	if success[rng.rand_weighted(weights)]:
		Global.current_energy += 1
		pe += 1
	else:
		ne += 1
	update_cells()
	print("AnomalyBar: Generated cell, pe: ", pe, ", ne: ", ne)
	Global.sync_manager._on_timer_timeout()

func update_cells() -> void:
	for i in range(pe_list.size()):
		pe_list[i].visible = i >= (MAX - pe) and i < MAX
	for i in range(ne_list.size()):
		ne_list[i].visible = i < ne

func get_sync_data() -> Dictionary:
	var pe_visibility = []
	for tex in pe_list:
		pe_visibility.append(tex.visible)
	var ne_visibility = []
	for tex in ne_list:
		ne_visibility.append(tex.visible)
	return {
		"pe": pe,
		"ne": ne,
		"pe_visibility": pe_visibility,
		"ne_visibility": ne_visibility,
		"global_energy": Global.current_energy,
		"anomaly_action_path": null if anomaly_action == null else anomaly_action.resource_path,
		"is_working": is_working
	}

func apply_sync_data(data: Dictionary) -> void:
	pe = data["pe"]
	ne = data["ne"]
	Global.current_energy = data["global_energy"]
	is_working = data["is_working"]
	if data["anomaly_action_path"] != null:
		var action = load(data["anomaly_action_path"])
		if action != null:
			anomaly_action = action
	for i in range(min(data["pe_visibility"].size(), pe_list.size())):
		pe_list[i].visible = data["pe_visibility"][i]
	for i in range(min(data["ne_visibility"].size(), ne_list.size())):
		ne_list[i].visible = data["ne_visibility"][i]
	if not multiplayer.is_server():
		if is_working and timer.is_stopped():
			timer.wait_time = TIME
			timer.start()
		elif not is_working:
			timer.stop()
	update_cells()
	print("AnomalyBar: Synced state, is_working: ", is_working, ", pe: ", pe, ", ne: ", ne)
		
func _on_drop_work():
	should_drop_work = true
