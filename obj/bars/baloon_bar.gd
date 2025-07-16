extends AnomalyBar
class_name BalloonBar

@onready var state_label = $StateLabel
@onready var history_label = $HistoryLabel

var interaction_history: Array[String] = []

func _ready() -> void:
	super._ready()
	update_display()

func work(action: AnomalyAction):
	interaction_history.append(action.action_name + " (" + Time.get_time_string_from_system() + ")")
	if interaction_history.size() > 5:  # Keep only last 5 interactions
		interaction_history.pop_front()
	update_display()
	super.work(action)

func update_display():
	if chamber and chamber.anomaly and chamber.anomaly.has_method("get_state"):
		var state = chamber.anomaly.get_state()
		state_label.text = "State: " + ("RED" if state == 1 else "Normal")
	history_label.text = "History:\n" + "\n".join(interaction_history)
