extends Entity

@export var anomaly_res: AbnormalityResource
@export var behavior_instance: GDScript
signal set_behaviour(new_behavior: GDScript)
#func _init():
	#set_behaviour.connect(_set_behaviour)

func _ready():
	pass
	#if anomaly_res and anomaly_res.behaviour:
		## Creates and attaches behavior
		#behavior_instance = anomaly_res.behaviour.new()
		#behavior_instance.abno = self
		#behavior_instance._ready()
		

#func _process(delta):
	#if behavior_instance:
		#behavior_instance._process(delta)
		#
#func _set_behaviour(new_behavior: GDScript):
	#if behavior_instance and behavior_instance.is_processing():
		#behavior_instance.set_process(false)
		#behavior_instance.queue_free()
		#behavior_instance = new_behavior.new()
		#behavior_instance.abno = self
		#behavior_instance._ready()
