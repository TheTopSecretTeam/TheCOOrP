extends VBoxContainer

var agent_picture = preload("res://img/Player.png")
var agent_sprite = null


@onready var weapon_list: ItemList =$Layout/TabContainer/Weapon
@onready var armor_list: ItemList = $Layout/TabContainer/Armor
@onready var agent_list: ItemList = $Layout/Layout/Layout/Agents
@onready var selection_display = $Layout/Layout/Layout/Display

@onready var agent_icon: TextureRect = $Layout/Layout/Layout/Display/AgentSprite
@onready var agent_name_label: Label = $Layout/Layout/Layout/Display/AgentName
@onready var armor_name_label: Label = $Layout/Layout/Layout/Display/ArmorName
@onready var weapon_name_label: Label = $Layout/Layout/Layout/Display/WeaponName

var weapons: Array[WeaponStats] = []
var armors: Array[ArmorStats] = []
var agents: Array[AgentStats] = []

var selected_agent: AgentStats = null

func _ready():

	populate_armor_list()
	populate_weapon_list()
	populate_agent_list()
	
	weapon_list.item_selected.connect(_on_weapon_selected)
	armor_list.item_selected.connect(_on_armor_selected)
	agent_list.item_selected.connect(_on_agent_selected)
	
	create_agent_sprite()
	clear_display()

func create_missing_icon():
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0.0))
	var texture = ImageTexture.create_from_image(image)
	return texture

func create_agent_sprite():
	agent_sprite = AtlasTexture.new()
	agent_sprite.atlas = agent_picture
	agent_sprite.region = Rect2(0, 0, agent_picture.get_width() / 3,\
									agent_picture.get_height())

func populate_weapon_list():
	weapon_list.clear()
	for weapon in weapons:
		var icon = weapon.sprite
		if icon == null:
			icon = create_missing_icon()
		weapon_list.add_item(weapon.name, icon)
		weapon_list.set_item_tooltip(-1, weapon.name)

func populate_armor_list():
	armor_list.clear()
	for armor in armors:
		var icon = armor.sprite
		if icon == null:
			icon = create_missing_icon()
		armor_list.add_item(armor.name, icon)
		armor_list.set_item_tooltip(-1, armor.name)

func populate_agent_list():
	agent_list.clear()
	for agent in agents:
		agent_list.add_item(agent.agent_name, agent_sprite)
		agent_list.set_item_tooltip(-1, agent.agent_name)

func update_armor_list():
	armor_list.clear()
	for armor in armors:
		var assigned_to = ""
		for agent in agents:
			if agent.current_armor == armor:
				assigned_to = agent.agent_name
				break
		
		var item_text = armor.name
		if assigned_to != "":
			item_text += " (%s)" % assigned_to
		
		armor_list.add_item(item_text, armor.sprite)
		armor_list.set_item_tooltip(-1, armor.name)
		
		if assigned_to != "" and (selected_agent == null or selected_agent.current_armor != armor):
			armor_list.set_item_disabled(-1, true)

func update_weapon_list():
	weapon_list.clear()
	for weapon in weapons:
		var assigned_to = ""
		for agent in agents:
			if agent.current_weapon == weapon:
				assigned_to = agent.agent_name
				break
		
		var item_text = weapon.name
		if assigned_to != "":
			item_text += " (%s)" % assigned_to
		
		weapon_list.add_item(item_text, weapon.sprite)
		weapon_list.set_item_tooltip(-1, weapon.name)
		
		if assigned_to != "" and (selected_agent == null or selected_agent.current_weapon != weapon):
			weapon_list.set_item_disabled(-1, true)

func clear_display():
	agent_icon.texture = null
	agent_name_label.text = ""
	armor_name_label.text = ""
	weapon_name_label.text = ""

func update_display():
	if selected_agent == null:
		clear_display()
		return
	
	agent_icon.texture = agent_sprite
	agent_icon.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	agent_icon.size_flags_vertical = Control.SIZE_EXPAND_FILL
	agent_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	agent_name_label.text = "Agent: " + selected_agent.agent_name
	armor_name_label.text = "Armor: " + selected_agent.current_armor.name
	weapon_name_label.text = "Weapon: " + selected_agent.current_weapon.name

func _on_agent_selected(index: int):
	selected_agent = agents[index]
	update_display()
	update_armor_list()
	update_weapon_list()

func _on_armor_selected(index: int):
	if selected_agent == null:
		return
	
	var armor_name = armors[index].name
	selected_agent.current_armor = armors[index]
	update_display()
	update_armor_list()
	update_weapon_list()

func _on_weapon_selected(index: int):
	if selected_agent == null:
		return
	
	var weapon_name = weapons[index].name
	selected_agent.current_weapon = weapons[index]
	update_display()
	update_armor_list()
	update_weapon_list()

func _on_exit_button_down():
	hide()
	agent_list.clear()
	armor_list.clear()
	weapon_list.clear()
	clear_display()
	return "SUCCESS"

func clear():
	weapon_list.clear()
	armor_list.clear()
	agent_list.clear()

func window_call(agent_res:Array[AgentStats], armor_res:Array[ArmorStats],
				 weapon_res:Array[WeaponStats]):
	clear()
	agents = agent_res
	armors = armor_res
	weapons = weapon_res
	
	populate_armor_list()
	populate_weapon_list()
	populate_agent_list()
	
	clear_display()
	show()
