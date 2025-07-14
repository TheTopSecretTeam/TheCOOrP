extends CanvasLayer

# Save paths
const SAVE_DIR = "user://saves/"
const SAVE_FILE_TEMPLATE = "save_{datetime}.save"

# Called when the node enters the scene tree
func _ready():
	# Ensure save directory exists
	DirAccess.make_dir_absolute(SAVE_DIR)

# Get current timestamp for filename
func _get_datetime_string() -> String:
	var datetime = Time.get_datetime_dict_from_system()
	return "{year}-{month}-{day}_{hour}-{minute}-{second}".format({
		"year": datetime["year"],
		"month": str(datetime["month"]).pad_zeros(2),
		"day": str(datetime["day"]).pad_zeros(2),
		"hour": str(datetime["hour"]).pad_zeros(2),
		"minute": str(datetime["minute"]).pad_zeros(2),
		"second": str(datetime["second"]).pad_zeros(2)
	})


func get_all_saves() -> Array:
	var saves := []
	var dir = DirAccess.open(SAVE_DIR)
	if not dir:
		return saves

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".save"):
			saves.append(SAVE_DIR.path_join(file_name))
		file_name = dir.get_next()
	dir.list_dir_end()
	
	return saves

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
			save_data["agents"].append({
				"name": agent.entity_resource.agent_name,
				"progress": agent.progress,
				"state": agent.state,
				"working": agent.working,
				"health": agent.entity_resource.current_hp,
				"flipped": agent.flipped,
				"current_room": agent.current_room,
				"path": agent.path,
				"waypoint": (
					null if agent.waypoint == null or not agent.waypoint.is_inside_tree()
					else agent.waypoint.get_path()
				)
			})

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

# Save game to file
func save_game() -> bool:
	var save_data = _generate_save_data()
	var datetime = _get_datetime_string()
	var save_path = SAVE_DIR.path_join(SAVE_FILE_TEMPLATE.format({"datetime": datetime}))

	var err = DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	if err != OK:
		push_error("Cannot create saving dir: " + SAVE_DIR)
		return false
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if not file:
		push_error("Failed to save game!")
		return false

	file.store_line(JSON.stringify(save_data, "\t"))
	print("Game saved to: ", save_path)
	return true

func load_game(save_path: String) -> bool:
	if not FileAccess.file_exists(save_path):
		push_error("Save file not found!")
		return false

	var file = FileAccess.open(save_path, FileAccess.READ)
	if not file:
		push_error("Failed to load save file!")
		return false

	var json_text = file.get_as_text()
	var save_data = JSON.parse_string(json_text)
	if not save_data:
		push_error("Invalid save data!")
		return false

	# Restore global state
	Global.resources = save_data["global"]["resources"].duplicate()
	Global.energy_quota = save_data["global"]["energy"]["quota"]
	Global.current_energy = save_data["global"]["energy"]["current"]

	# Restore agents
	for agent_data in save_data["agents"]:
		for agent in Agents.agents:
			if is_instance_valid(agent) and agent.entity_resource.agent_name == agent_data["name"]:
				agent.progress = agent_data["progress"]
				agent.state = agent_data["state"]
				agent.working = agent_data["working"]
				agent.entity_resource.current_hp = agent_data["health"]
				agent.flipped = agent_data["flipped"]
				agent.current_room = agent_data["current_room"]
				agent.path = agent_data["path"]
				agent.waypoint = Map.get_map_node(agent_data["waypoint"])
				break

	## Restore abnormalities
	#var abnormalities = get_tree().get_nodes_in_group("Abnormality")
	#for ab_data in save_data["abnormalities"]:
		#for ab in abnormalities:
			#if ab.current_room == ab_data["room"]:  # Simplified matching
				#ab.current_room = ab_data["room"]
				#ab.progress = ab_data["progress"]
				#ab.state = ab_data["state"]
				#ab.flipped = ab_data["flipped"]
				#break

	print("Game loaded from: ", save_path)
	return true


# Quick save/load shortcuts
func quick_save() -> bool:
	return save_game()

func quick_load() -> bool:
	var latest_save = _get_latest_save()
	if latest_save:
		return load_game(latest_save)
	return false

# Get most recent save file
func _get_latest_save() -> String:
	var dir = DirAccess.open(SAVE_DIR)
	if not dir:
		return ""

	var latest_time = 0
	var latest_file = ""

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".save"):
			var file_time = FileAccess.get_modified_time(SAVE_DIR.path_join(file_name))
			if file_time > latest_time:
				latest_time = file_time
				latest_file = SAVE_DIR.path_join(file_name)
		file_name = dir.get_next()

	return latest_file
