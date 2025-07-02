extends TabContainer
var anomaly : AbnormalityResource
var main_open_cost = 0
var action_open_cost = 0
var info_open_cost = 0
var stast_open_cost = 0
var equip_open_cost = 0

func update_resources() -> void:
	var info_scene = preload("res://UI/research_menu_components/info.tscn")
	for child in $HBoxContainer/VBoxContainer/Resources.get_children():
		child.get_parent().remove_child(child)
	$HBoxContainer/VBoxContainer/Unique_PE.text = "PE: " + str(anomaly.unique_pe)
	for resource in Global.resources:
		print("B")
		var info_instance = info_scene.instantiate()
		info_instance.text = resource + ": " + str(Global.resources[resource])
		$HBoxContainer/VBoxContainer/Resources.add_child(info_instance)
		info_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_instance.size_flags_vertical = Control.SIZE_EXPAND_FILL
	Global.resources_changed.emit(Global.resources)


func _on_open_weapon_button_down() -> void:
	if anomaly.unique_pe < anomaly.equip_cost: return
	anomaly.unique_pe -= anomaly.equip_cost
	update_pe_display()
	anomaly.weapon_open = true
	$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.hide()
	$HBoxContainer/VBoxContainer3/Shop/Weapon.show()
	update_resources()
	if !anomaly.sold_weapon: return
	var buttontext = ""
	var counter = 0
	for res in Global.resources:
		print("A")
		if Global.resources[res] != 0: buttontext += res + ": " + str(anomaly.weapon_cost[counter]) + " "
		counter+=1
	$HBoxContainer/VBoxContainer3/BuyButtons/WeaponButtCont/BuyWeapon.text = buttontext
	$HBoxContainer/VBoxContainer3/BuyButtons/WeaponButtCont/BuyWeapon.show()

func _on_open_armor_button_down() -> void:
	if anomaly.unique_pe < anomaly.equip_cost: return
	anomaly.unique_pe -= anomaly.equip_cost
	update_pe_display()
	anomaly.armor_open = true
	$HBoxContainer/VBoxContainer3/Shop/OpenArmor.hide()
	$HBoxContainer/VBoxContainer3/Shop/Armor.show()
	update_resources()
	if !anomaly.sold_armor: return
	var buttontext = ""
	var counter = 0
	for res in Global.resources:
		print("A")
		if Global.resources[res] != 0: buttontext += res + ": " + str(anomaly.armor_cost[counter]) + " "
		counter+=1
	$HBoxContainer/VBoxContainer3/BuyButtons/ArmorButtCont/BuyArmor.text = buttontext
	$HBoxContainer/VBoxContainer3/BuyButtons/ArmorButtCont/BuyArmor.show()

func _on_open_work_1_button_down() -> void:
	if anomaly.unique_pe < action_open_cost: return
	anomaly.unique_pe -= action_open_cost
	update_pe_display()
	anomaly.actions_open[0] = true
	$HBoxContainer/VBoxContainer2/GridContainer/OpenWork1.hide()
	$HBoxContainer/VBoxContainer2/GridContainer/work1.show()
	update_resources()

func _on_open_work_2_button_down() -> void:
	if anomaly.unique_pe < action_open_cost: return
	anomaly.unique_pe -= action_open_cost
	update_pe_display()
	anomaly.actions_open[1] = true
	$HBoxContainer/VBoxContainer2/GridContainer/OpenWork2.hide()
	$HBoxContainer/VBoxContainer2/GridContainer/work2.show()
	update_resources()

func _on_open_work_3_button_down() -> void:
	if anomaly.unique_pe < action_open_cost: return
	anomaly.unique_pe -= action_open_cost
	update_pe_display()
	anomaly.actions_open[2] = true
	$HBoxContainer/VBoxContainer2/GridContainer/OpenWork3.hide()
	$HBoxContainer/VBoxContainer2/GridContainer/work3.show()
	update_resources()

func _on_open_work_4_button_down() -> void:
	if anomaly.unique_pe < action_open_cost: return
	anomaly.unique_pe -= action_open_cost
	update_pe_display()
	anomaly.actions_open[3] = true
	$HBoxContainer/VBoxContainer2/GridContainer/OpenWork4.hide()
	$HBoxContainer/VBoxContainer2/GridContainer/work4.show()
	update_resources()

func _on_exit_button_down() -> void:
	hide()
	for child in $HBoxContainer/VBoxContainer/Resources.get_children():
		child.get_parent().remove_child(child)
	for child in $HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		child.get_parent().remove_child(child)

func _on_info_open_button_down(info: int) -> void:
	if anomaly.unique_pe < info_open_cost: return
	anomaly.unique_pe -= info_open_cost
	update_pe_display()
	anomaly.mechanics_open[info]
	$HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_child(info * 2).show()
	$HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_child(info * 2 + 1).hide()

func _on_open_main_button_down() -> void:
	if anomaly.unique_pe < main_open_cost: return
	anomaly.unique_pe -= main_open_cost
	anomaly.main_open = true
	$HBoxContainer/VBoxContainer/TextureRect.show()
	$HBoxContainer/VBoxContainer/Name.show()
	$HBoxContainer/VBoxContainer/OpenMain.hide()

func _on_open_escape_stats_button_down() -> void:
	if anomaly.unique_pe < stast_open_cost: return
	anomaly.unique_pe -= main_open_cost
	anomaly.stats_open = true
	$HBoxContainer/VBoxContainer3/EscapeStats.show()
	$HBoxContainer/VBoxContainer3/OpenEscapeStats.hide()

func _on_buy_weapon_button_down() -> void:
	var counter = 0
	for res in Global.resources:
		if Global.resources[res] < anomaly.weapon_cost[counter]: return
		counter+=1
	counter = 0
	for res in Global.resources:
		Global.resources[res] -= anomaly.weapon_cost[counter]
		counter+=1
	$HBoxContainer/VBoxContainer3/BuyButtons/WeaponButtCont/BuyWeapon.hide()
	update_resources()

func _on_buy_armor_button_down() -> void:
	var counter = 0
	for res in Global.resources:
		if Global.resources[res] < anomaly.armor_cost[counter]: return
		counter+=1
	counter = 0
	for res in Global.resources:
		Global.resources[res] -= anomaly.armor_cost[counter]
		counter+=1
	$HBoxContainer/VBoxContainer3/BuyButtons/ArmorButtCont/BuyArmor.hide()
	update_resources()

#func _on_open_mechanics_button_down(index: int) -> void:
	#if index >= anomaly.mechanics_open.size() or anomaly.mechanics_open[index] or anomaly.unique_pe < anomaly.mechanics_cost[index]:
		#return
	#anomaly.unique_pe -= anomaly.mechanics_cost[index]
	#update_pe_display()
	#anomaly.mechanics_open[index] = true
	#
	#var container = $HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer
	#var button = container.get_node("MechButton%d" % index)
	#var info = container.get_node("MechInfo%d" % index)
	#button.hide()
	#info.show()
	
func update_pe_display() -> void:
	$HBoxContainer/VBoxContainer/Unique_PE.text = "PE: " + str(anomaly.unique_pe)
	
func window_call(res: AbnormalityResource) -> void:
	anomaly = res
	main_open_cost = anomaly.threat_level
	action_open_cost = anomaly.threat_level
	info_open_cost = anomaly.threat_level
	stast_open_cost = anomaly.threat_level
	equip_open_cost = anomaly.threat_level
	print("C")
	print(equip_open_cost)
	
	$HBoxContainer/VBoxContainer/Unique_PE.text = "PE: " + str(anomaly.unique_pe)
	$HBoxContainer/VBoxContainer/Name.text = anomaly.monster_name
	$HBoxContainer/VBoxContainer/TextureRect.texture = anomaly.texture
	$HBoxContainer/VBoxContainer/Description.text = anomaly.description
	
	$Lore/VBoxContainer/TextureRect.texture = anomaly.profile
	$Lore/VBoxContainer/Name.text = anomaly.monster_name
	$Lore/VBoxContainer3/LoreText.text = anomaly.lore
	
	if anomaly.damage_res_phys != 0 and anomaly.damage_res_ment != 0:
		$HBoxContainer/VBoxContainer3/EscapeStats.text = "Physcial Resistance: %d | Mental Resistance: %d" % [anomaly.damage_res_phys, anomaly.damage_res_ment]
	
	if anomaly.sold_weapon:
		var weapon = anomaly.sold_weapon
		$HBoxContainer/VBoxContainer3/Shop/Weapon/GridContainer/Texture.texture = weapon.sprite
		$HBoxContainer/VBoxContainer3/Shop/Weapon/Stats.text = "%s Damage: %d \n Attack Speed: %d \n Range: %d" % [weapon.damage_type, weapon.base_damage, weapon.attack_speed, weapon.weapon_range]
		$HBoxContainer/VBoxContainer3/Shop/Weapon/SpecialEffects.text = weapon.special_effects_text
	if anomaly.sold_armor:
		var armor = anomaly.sold_armor
		$HBoxContainer/VBoxContainer3/Shop/Armor/GridContainer/Texture.texture = armor.sprite
		$HBoxContainer/VBoxContainer3/Shop/Armor/Resistances.text = "Physical Resistance: %f \n Mental Resistance: %f" % [armor.physical_resistance, armor.mental_resistance]
		$HBoxContainer/VBoxContainer3/Shop/Armor/SpecialEffects.text = armor.special_effects_text
	
	if anomaly.actions_open[0]:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork1.hide()
		$HBoxContainer/VBoxContainer2/GridContainer/work1.show()
	else:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork1.text = "Purchase: " + str(action_open_cost)
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork1.show()
		$HBoxContainer/VBoxContainer2/GridContainer/work1.hide()
	
	if anomaly.actions_open[1]:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork2.hide()
		$HBoxContainer/VBoxContainer2/GridContainer/work2.show()
	else:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork2.text = "Purchase: " + str(action_open_cost)
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork2.show()
		$HBoxContainer/VBoxContainer2/GridContainer/work2.hide()
	
	if anomaly.actions_open[2]:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork3.hide()
		$HBoxContainer/VBoxContainer2/GridContainer/work3.show()
	else:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork3.text = "Purchase: " + str(action_open_cost)
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork3.show()
		$HBoxContainer/VBoxContainer2/GridContainer/work3.hide()
	
	if anomaly.actions_open[3]:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork4.hide()
		$HBoxContainer/VBoxContainer2/GridContainer/work4.show()
	else:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork4.text = "Purchase: " + str(action_open_cost)
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork4.show()
		$HBoxContainer/VBoxContainer2/GridContainer/work4.hide()
	
	if anomaly.weapon_open:
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.hide()
		$HBoxContainer/VBoxContainer3/Shop/Weapon.show()
		$HBoxContainer/VBoxContainer3/BuyButtons/WeaponButtCont/BuyWeapon.show()
	else:
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.text = "Open: " + str(equip_open_cost)
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.show()
		$HBoxContainer/VBoxContainer3/Shop/Weapon.hide()
		
	if anomaly.armor_open:
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.hide()
		$HBoxContainer/VBoxContainer3/Shop/Armor.show()
		$HBoxContainer/VBoxContainer3/BuyButtons/ArmorButtCont/BuyArmor.show()
	else:
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.text = "Open: " + str(equip_open_cost)
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.show()
		$HBoxContainer/VBoxContainer3/Shop/Armor.hide()
		$HBoxContainer/VBoxContainer3/BuyButtons/ArmorButtCont/BuyArmor.hide()
		
	var info_scene = preload("res://UI/research_menu_components/info.tscn")
	for i in anomaly.mechanics_info.size():
		var info_instance = info_scene.instantiate()
		var info_open_button = Button.new()
		info_open_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_open_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		info_open_button.button_down.connect(_on_info_open_button_down.bind(i))
		info_instance.text = anomaly.mechanics_info[i]
		$HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(info_instance)
		$HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(info_open_button)
		if anomaly.mechanics_open[i]:
			info_instance.show()
			info_open_button.hide()
		else:
			info_instance.hide()
			info_open_button.text = "Open: " + str(info_open_cost)
			info_open_button.show()
	
	
	for resource in Global.resources:
		print("B")
		var info_instance = info_scene.instantiate()
		info_instance.text = resource + ": " + str(Global.resources[resource])
		$HBoxContainer/VBoxContainer/Resources.add_child(info_instance)
		info_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info_instance.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	$HBoxContainer/VBoxContainer2/GridContainer/work1/VBoxContainer/TextureRect.texture = anomaly.actions[0].action_icon
	$HBoxContainer/VBoxContainer2/GridContainer/work2/VBoxContainer/TextureRect.texture = anomaly.actions[1].action_icon
	$HBoxContainer/VBoxContainer2/GridContainer/work3/VBoxContainer/TextureRect.texture = anomaly.actions[2].action_icon
	$HBoxContainer/VBoxContainer2/GridContainer/work4/VBoxContainer/TextureRect.texture = anomaly.actions[3].action_icon
	
	$HBoxContainer/VBoxContainer2/GridContainer/work1/Label.text = str(anomaly.actions[0].probability * 100) + "%"
	$HBoxContainer/VBoxContainer2/GridContainer/work2/Label.text = str(anomaly.actions[1].probability * 100) + "%"
	$HBoxContainer/VBoxContainer2/GridContainer/work3/Label.text = str(anomaly.actions[2].probability * 100) + "%"
	$HBoxContainer/VBoxContainer2/GridContainer/work4/Label.text = str(anomaly.actions[3].probability * 100) + "%"
	
	$HBoxContainer/VBoxContainer2/GridContainer/work1/VBoxContainer/Label.text = anomaly.actions[0].action_name
	$HBoxContainer/VBoxContainer2/GridContainer/work2/VBoxContainer/Label.text = anomaly.actions[1].action_name
	$HBoxContainer/VBoxContainer2/GridContainer/work3/VBoxContainer/Label.text = anomaly.actions[2].action_name
	$HBoxContainer/VBoxContainer2/GridContainer/work4/VBoxContainer/Label.text = anomaly.actions[3].action_name
	
	var mech_button_scene = preload("res://UI/research_menu_components/mech_button.tscn")
	#for i in range(anomaly.mechanics_info.size()):
		#var info_instance = info_scene.instantiate()
		#info_instance.name = "MechInfo%d" % i
		#info_instance.text = anomaly.mechanics_info[i]
		#$HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(info_instance)
		#
		#var button = mech_button_scene.instantiate()
		#button.name = "MechButton%d" % i
		#button.text = "Purchase: %d" % anomaly.mechanics_cost[i]
		#button.pressed.connect(_on_open_mechanics_button_down.bind(i))
		#$HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(button)
		#
		#if anomaly.mechanics_open[i]:
			#button.hide()
			#info_instance.show()
		#else:
			#button.show()
			#info_instance.hide()
	
	# $HBoxContainer/VBcoxContainer3/EscapeStats.text = str(anomaly.damage_res_phys) + " " + str(anomaly.damage_res_ment)
	
	if anomaly.weapon_open:
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.hide()
		$HBoxContainer/VBoxContainer3/Shop/Weapon.show()
		$HBoxContainer/VBoxContainer3/BuyButtons/WeaponButtCont/BuyWeapon.show()
	else:
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.text = "Purchase: " + str(anomaly.equip_cost)
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.show()
		$HBoxContainer/VBoxContainer3/Shop/Weapon.hide()
		$HBoxContainer/VBoxContainer3/BuyButtons/WeaponButtCont/BuyWeapon.hide()
		
	if anomaly.armor_open:
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.hide()
		$HBoxContainer/VBoxContainer3/Shop/Armor.show()
		$HBoxContainer/VBoxContainer3/BuyButtons/ArmorButtCont/BuyArmor.show()
	else:
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.text = "Purchase: " + str(anomaly.equip_cost)
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.show()
		$HBoxContainer/VBoxContainer3/Shop/Armor.hide()
		$HBoxContainer/VBoxContainer3/BuyButtons/ArmorButtCont/BuyArmor.hide()
		
	self.show()
