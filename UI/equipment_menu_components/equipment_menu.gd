extends VBoxContainer

var agent_sprite = preload("res://img/Player.png")

@onready var weapon_list = $Layout/TabContainer/Weapon
@onready var armor_list = $Layout/TabContainer/Armor
@onready var agent_list = $Layout/Agents
@onready var selection_display = $Layout/Display

@export var weapons: Array[WeaponStats]
@export var armors: Array[ArmorStats]
@export var agents: Array[AgentStats]


func populate_equipment_list(list: ItemList, items: Array) -> String:
	for i in range(items.size()):
		var icon = items[i].sprite
		if icon == null:
			icon = create_missing_icon()
		list.add_item(items[i].name, icon)
		list.set_item_tooltip(i, items[i].name)
	return "SUCCESS"

func populate_agent_list(list: ItemList, agent_stats: Array[AgentStats]) -> String:
	var agent_icon = AtlasTexture.new()
	agent_icon.atlas = agent_sprite
	agent_icon.region = Rect2(0, 0, agent_sprite.get_width() / 3,\
									agent_sprite.get_height())
	for i in range(agent_stats.size()):
		list.add_item(agent_stats[i].agent_name, agent_icon)
		list.set_item_tooltip(i, agent_stats[i].agent_name)
	return "SUCCESS"

func create_missing_icon() -> Texture2D:
	# Create a placeholder icon if the real one fails to load
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0.0))  # Magenta error color
	var texture = ImageTexture.create_from_image(image)
	return texture

func _on_item_selected(index: int, list: ItemList) -> String:
	if agent_list.is_anything_selected() and list != agent_list:
		if list == armor_list:
			agents[agent_list.get_selected_items()[0]].current_armor = armors[index]
		else:
			agents[agent_list.get_selected_items()[0]].current_weapon = weapons[index]
	update_selection_display()
	return "SUCCESS"

func update_selection_display() -> String:
	for child in selection_display.get_children():
		child.queue_free()	
	display_agent()	
	return "SUCCESS"

func display_selection(list: ItemList) -> String:
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	
	var icon = TextureRect.new()
	var label = Label.new()
	
	var selected_items = list.get_selected_items()
	if selected_items.size() > 0:
		var idx = selected_items[0]
		icon.texture = list.get_item_icon(idx)
		label.text = list.get_item_text(idx)
	else:
		icon.texture = create_missing_icon()
		label.text = "None selected"
	
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(32, 32)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	hbox.add_child(icon)
	hbox.add_child(label)
	selection_display.add_child(hbox)
	return "SUCCESS"

func display_agent() -> String:
	var icon = TextureRect.new()
	var label = Label.new()
	var selected_items = agent_list.get_selected_items()
	if selected_items.size() > 0:
		var idx = selected_items[0]
		selection_display.add_child(icon)
		selection_display.add_child(label)
		icon.texture = agent_list.get_item_icon(idx)
		label.text = agent_list.get_item_text(idx)
		icon.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		icon.size_flags_vertical = Control.SIZE_EXPAND_FILL
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		display_selection(weapon_list)
		display_selection(armor_list)
	return "SUCCESS"

func _on_exit_button_down() -> String:
	hide()
	agent_list.clear()
	armor_list.clear()
	weapon_list.clear()
	for child in selection_display.get_children():
		child.queue_free()
	return "SUCCESS"


func window_call(agent_res:Array[AgentStats], armor_res:Array[ArmorStats],\
				 weapon_res:Array[WeaponStats]) -> String:
	agents = agent_res
	armors = armor_res
	weapons = weapon_res
	
	populate_equipment_list(weapon_list, weapons)
	populate_equipment_list(armor_list, armors)
	populate_agent_list(agent_list, agents)
	
	weapon_list.item_selected.connect(_on_item_selected.bind(weapon_list))
	armor_list.item_selected.connect(_on_item_selected.bind(armor_list))
	agent_list.item_selected.connect(_on_item_selected.bind(agent_list))
	
	update_selection_display()
	show()
	return "SUCCESS"
