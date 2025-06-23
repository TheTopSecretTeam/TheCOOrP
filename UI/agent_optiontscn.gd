extends MarginContainer

var agent : AgentStats
signal agent_selected

func _ready() -> void:
	$HBoxContainer/LinkButton.text = agent.agent_name
func _on_link_button_pressed() -> void:
	agent_selected.emit(agent.agent_name)
