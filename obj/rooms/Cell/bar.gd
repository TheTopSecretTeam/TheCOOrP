extends Sprite2D
class_name AnomalyBar

signal work_completed(pe_box)

@export var chamber : AnomalyChamber

var MAX = 10
var PROB = 0.6
var TIME = 1

var anomaly_action : AnomalyAction

var pe_list : Array[TextureRect]
var ne_list : Array[TextureRect]

var pe = 0
var ne = 0

var rng = RandomNumberGenerator.new()
@onready var pe_list_parent = $PE_list
@onready var ne_list_parent = $NE_list
func _ready() -> void:
	# change seed
	rng.seed = Global.Seed
	
	for child in pe_list_parent.get_children():
		pe_list.append(child)
		pe_list[-1].visible = false
	for child in ne_list_parent.get_children():
		ne_list.append(child)
		ne_list[-1].visible = false

func work(action : AnomalyAction):
	anomaly_action = action
	for child in pe_list_parent.get_children():
		pe_list.append(child)
		pe_list[-1].visible = false
	for child in ne_list_parent.get_children():
		ne_list.append(child)
		ne_list[-1].visible = false
	PROB = action.probability
	pe = 0
	ne = 0
	rng.randomize()
	$Timer.wait_time = TIME
	$Timer.start()

func _on_timer_timeout():
	if ne + pe < MAX:
		generate_cell(PROB)
	else:
		$Timer.stop()
		_on_bar_work_completed.rpc(pe)


func generate_cell(prob: float) -> void:
	if !multiplayer.has_multiplayer_peer() or multiplayer.is_server(): 
		var success = [true, false]
		var weights = PackedFloat32Array([prob, 1-prob])
		if success[rng.rand_weighted(weights)]:
			Global.current_energy += 1
			pe += 1
			pe_list[MAX - pe].visible = true
		else:
			ne += 1
			ne_list[ne - 1].visible = true

	
# NET

@rpc("any_peer", "call_local")
func _on_bar_work_completed(pe_box: Variant) -> void:
	work_completed.emit(pe_box)



func get_sync_data() -> Dictionary:
	# Instead of sending the entire TextureRect arrays,
	# send only the visibility states and counts
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
		"anomaly_action_path": null if anomaly_action == null else anomaly_action.resource_path
	}

func apply_sync_data(data: Dictionary) -> void:
	pe = data["pe"]
	ne = data["ne"]
	Global.current_energy = data["global_energy"]
	
	var action = load(data["anomaly_action_path"])
	if action != null:
		anomaly_action = action
	
	# Restore visibility states
	for i in range(min(data["pe_visibility"].size(), pe_list.size())):
		pe_list[i].visible = data["pe_visibility"][i]
	
	for i in range(min(data["ne_visibility"].size(), ne_list.size())):
		ne_list[i].visible = data["ne_visibility"][i]
