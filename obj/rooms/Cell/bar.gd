extends Sprite2D

signal work_completed(pe_box)

var MAX = 10
var PROB = 0.6
var TIME = 1

var pe_list : Array[TextureRect]
var ne_list : Array[TextureRect]

var pe = 0
var ne = 0

var rng = RandomNumberGenerator.new()
var timer = Timer.new()
@onready var pe_list_parent = $PE_list
@onready var ne_list_parent = $NE_list
func _ready() -> void:
	for child in pe_list_parent.get_children():
		pe_list.append(child)
		pe_list[-1].visible = false
	for child in ne_list_parent.get_children():
		ne_list.append(child)
		ne_list[-1].visible = false
	
func work(probability):
	for child in pe_list_parent.get_children():
		pe_list.append(child)
		pe_list[-1].visible = false
	for child in ne_list_parent.get_children():
		ne_list.append(child)
		ne_list[-1].visible = false
	PROB = probability
	pe = 0
	ne = 0
	rng.randomize()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = TIME
	timer.start()

func _on_timer_timeout():
	if ne + pe < MAX:
		generate_cell(PROB)
	else:
		timer.stop()
		work_completed.emit(pe)

func generate_cell(prob: float) -> void:
	var success = [true, false]
	var weights = PackedFloat32Array([prob, 1-prob])
	if success[rng.rand_weighted(weights)]:
		pe += 1
		pe_list[MAX - pe].visible = true
	else:
		ne += 1
		ne_list[ne - 1].visible = true
