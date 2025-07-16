extends AnomalyLogic
class_name BalloonAnomaly

enum BaloonState { NORMAL, RED }

var current_state: BaloonState = BaloonState.NORMAL
var last_action_was_pop: bool = false

func get_state() -> int:
	return current_state

func start_work():
	RP = 0
	FP = 0

func work_tick():
	if RP + FP < MAX:
		generate_cell(PROB)
	else:
		handle_work_completion()

func handle_work_completion():
	match action.action_name:
		"Pop":
			current_state = BaloonState.RED
			last_action_was_pop = true
		"Pet":
			if current_state == BaloonState.RED:
				current_state = BaloonState.NORMAL
			last_action_was_pop = false
		"Observe":
			Global.research_points += RP * 0.5  # Small research gain
			last_action_was_pop = false
		"Compress":
			# Optional side effect can be added here
			last_action_was_pop = false
	
	# Check for deadly condition
	if last_action_was_pop and action.action_name != "Pet":
		kill_agent()
	
	work_completed.emit(RP)

func kill_agent():
	if agent:
		agent.die("Killed by the red balloon")
	current_state = BaloonState.NORMAL
	last_action_was_pop = false

func generate_cell(prob: float) -> void:
	var success = [true, false]
	var weights = PackedFloat32Array([prob, 1-prob])
	if success[rng.rand_weighted(weights)]:
		RP += 1
	else:
		FP += 1

func work_end():
	Global.current_energy += RP
