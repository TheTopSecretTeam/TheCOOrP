extends Node


# Generate save data structure
func _generate_save_data() -> Dictionary:
	var save_data := {
		# Global game state
		"global": {
			"resources": Global.resources.duplicate(),
			"energy": {
				"quota": Global.energy_quota,
				"current": Global.current_energy
			}
		},
		# Agents
		"agents": [],
		# Abnormalities
		"abnormalities": [],
	}

	# Save all agents
	for agent in Agents.agents:
		if is_instance_valid(agent):
			print(agent.entity_resource.agent_name, agent.current_room, agent.progress)
			save_data["agents"].append(agent.get_sync_data())

	## Save abnormalities
	#for ab in get_tree().get_nodes_in_group("Abnormality"):
		#if is_instance_valid(ab):
			#save_data["abnormalities"].append({
				#"room": ab.current_room,
				#"progress": ab.progress,
				#"state": ab.state,
				#"flipped": ab.flipped
			#})


	return save_data
