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

# Save game to file
func save_game() -> bool:
	var snapshot_generator = preload("res://saving/create_snapshot.gd").new()
	var save_data = snapshot_generator._generate_save_data()
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
				agent.apply_sync_data(agent_data)
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
