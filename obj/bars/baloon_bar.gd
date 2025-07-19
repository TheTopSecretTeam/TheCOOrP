extends AnomalyBar
class_name BalloonBar

@onready var state_label = $StateLabel
@onready var history_label = $HistoryLabel

var interaction_history: Array[String] = []

enum BaloonState { NORMAL, RED }

var current_state: BaloonState = BaloonState.NORMAL
var last_action_was_pop: bool = false

signal agent_kill_requested

func _ready() -> void:
	super._ready()
	update_display()

func work(action: AnomalyAction):
	interaction_history.append(action.action_name)
	if interaction_history.size() > 2:  # Keep only last 2 interactions
		interaction_history.pop_front()
	handle_work_completion(action)
	super.work(action)

func update_display():
	state_label.text = "State: " + ("RED" if current_state == BaloonState.RED else "NORMAL")
	history_label.text = "History:\n" + "\n".join(interaction_history)

func get_state() -> int:
	return current_state
	
func handle_work_completion(action: AnomalyAction):
	match action.action_name:
		"Pop":
			current_state = BaloonState.RED
			last_action_was_pop = true
			print(current_state)
			print(last_action_was_pop)
		"Pet":
			if current_state == BaloonState.RED:
				current_state = BaloonState.NORMAL
			last_action_was_pop = false
		"Observe":
			last_action_was_pop = false
		"Compress":
			# Optional side effect can be added here
			last_action_was_pop = false
	
	# Check for deadly condition
	if interaction_history.size() >= 2 and interaction_history[-2] == "Pop" and !(interaction_history [-1] == "Pet"):
		kill_agent()
	
	update_display()
	

func kill_agent():
	get_parent().agent_kill_requested.emit()
	current_state = BaloonState.NORMAL
	last_action_was_pop = false
