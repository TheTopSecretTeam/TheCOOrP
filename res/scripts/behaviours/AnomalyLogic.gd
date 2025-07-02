extends Resource

class_name AnomalyLogic

signal work_completed(RP)

@export var MAX = 10
@export var TIME = 1
@export var anomaly_res : AbnormalityResource
var PROB = 0.6
var RP = 0
var FP = 0

var agent : AgentStats
var action : AnomalyAction

var rng = RandomNumberGenerator.new()

func start_work():
	pass

func work_tick():
	pass

func work_end():
	pass
