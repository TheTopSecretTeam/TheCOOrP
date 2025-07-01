extends TabContainer
var anomaly : AbnormalityResource
var equip_cost : int

func _on_open_weapon_button_down() -> void:
	if anomaly.unique_pe < equip_cost: return
	anomaly.unique_pe -= equip_cost
	anomaly.weapon_open = true
	$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.hide()
	$HBoxContainer/VBoxContainer3/Shop/Weapon.show()
	var buttontext = ""
	var counter = 0
	for res in Global.resources:
		print("A")
		if Global.resources[res] != 0: buttontext += res + ": " + str(anomaly.weapon_cost[counter]) + " "
		counter+=1
	$HBoxContainer/VBoxContainer3/BuyButtons/BuyWeapon.text = buttontext
	$HBoxContainer/VBoxContainer3/BuyButtons/BuyWeapon.show()

func _on_open_armor_button_down() -> void:
	if anomaly.unique_pe < equip_cost: return
	anomaly.unique_pe -= equip_cost
	anomaly.armor_open = true
	$HBoxContainer/VBoxContainer3/Shop/OpenArmor.hide()
	$HBoxContainer/VBoxContainer3/Shop/Armor.show()
	var buttontext = ""
	var counter = 0
	for res in Global.resources:
		print("A")
		if Global.resources[res] != 0: buttontext += res + ": " + str(anomaly.armor_cost[counter]) + " "
		counter+=1
	$HBoxContainer/VBoxContainer3/BuyButtons/BuyArmor.text = buttontext
	$HBoxContainer/VBoxContainer3/BuyButtons/BuyArmor.show()


func _on_open_work_1_button_down() -> void:
	if anomaly.unique_pe < anomaly.actions_cost[0]: return
	anomaly.unique_pe -= anomaly.actions_cost[0]
	anomaly.actions_open[0] = true
	$HBoxContainer/VBoxContainer2/GridContainer/OpenWork1.hide()
	$HBoxContainer/VBoxContainer2/GridContainer/work1.show()

func _on_open_work_2_button_down() -> void:
	if anomaly.unique_pe < anomaly.actions_cost[1]: return
	anomaly.unique_pe -= anomaly.actions_cost[1]
	anomaly.actions_open[1] = true
	$HBoxContainer/VBoxContainer2/GridContainer/OpenWork2.hide()
	$HBoxContainer/VBoxContainer2/GridContainer/work2.show()

func _on_open_work_3_button_down() -> void:
	if anomaly.unique_pe < anomaly.actions_cost[2]: return
	anomaly.unique_pe -= anomaly.actions_cost[2]
	anomaly.actions_open[2] = true
	$HBoxContainer/VBoxContainer2/GridContainer/OpenWork3.hide()
	$HBoxContainer/VBoxContainer2/GridContainer/work3.show()

func _on_open_work_4_button_down() -> void:
	if anomaly.unique_pe < anomaly.actions_cost[3]: return
	anomaly.unique_pe -= anomaly.actions_cost[3]
	anomaly.actions_open[3] = true
	$HBoxContainer/VBoxContainer2/GridContainer/OpenWork4.hide()
	$HBoxContainer/VBoxContainer2/GridContainer/work4.show()


func _on_buy_weapon_button_down() -> void:
	var counter = 0
	for res in Global.resources:
		if Global.resources[res] < anomaly.weapon_cost[counter]: return
		Global.resources[res] -= anomaly.weapon_cost[counter]
		counter+=1
	$HBoxContainer/VBoxContainer3/BuyButtons/BuyWeapon.hide()
	print("bought")

func _on_buy_armor_button_down() -> void:
	var counter = 0
	for res in Global.resources:
		if Global.resources[res] < anomaly.armor_cost[counter]: return
		Global.resources[res] -= anomaly.armor_cost[counter]
		counter+=1
	$HBoxContainer/VBoxContainer3/BuyButtons/BuyArmor.hide()
	print("bought")


func _on_exit_button_down() -> void:
	hide()
	for child in $HBoxContainer/VBoxContainer/Resources.get_children():
		child.get_parent().remove_child(child)
	for child in $HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.get_children():
		child.get_parent().remove_child(child)

func window_call(res: AbnormalityResource) -> void:
	anomaly = res
	equip_cost = anomaly.threat_level
	print("C")
	print(equip_cost)
	
	$HBoxContainer/VBoxContainer/Unique_PE.text = "PE: " + str(anomaly.unique_pe)
	$HBoxContainer/VBoxContainer/Name.text = anomaly.monster_name
	$HBoxContainer/VBoxContainer/TextureRect.texture = anomaly.texture
	$HBoxContainer/VBoxContainer/Description.text = anomaly.description

	if anomaly.actions_open[0]:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork1.hide()
		$HBoxContainer/VBoxContainer2/GridContainer/work1.show()
	else:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork1.text = "Purchase: " + str(anomaly.actions_cost[0])
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork1.show()
		$HBoxContainer/VBoxContainer2/GridContainer/work1.hide()
	
	if anomaly.actions_open[1]:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork2.hide()
		$HBoxContainer/VBoxContainer2/GridContainer/work2.show()
	else:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork2.text = "Purchase: " + str(anomaly.actions_cost[1])
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork2.show()
		$HBoxContainer/VBoxContainer2/GridContainer/work2.hide()
	
	if anomaly.actions_open[2]:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork3.hide()
		$HBoxContainer/VBoxContainer2/GridContainer/work3.show()
	else:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork3.text = "Purchase: " + str(anomaly.actions_cost[2])
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork3.show()
		$HBoxContainer/VBoxContainer2/GridContainer/work3.hide()
	
	if anomaly.actions_open[3]:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork4.hide()
		$HBoxContainer/VBoxContainer2/GridContainer/work4.show()
	else:
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork4.text = "Purchase: " + str(anomaly.actions_cost[3])
		$HBoxContainer/VBoxContainer2/GridContainer/OpenWork4.show()
		$HBoxContainer/VBoxContainer2/GridContainer/work4.hide()
	
	var info_scene = preload("res://UI/research_menu_components/info.tscn")
	for resource in Global.resources:
		print("B")
		var info_instance = info_scene.instantiate()
		info_instance.text = resource + ": " + str(Global.resources[resource])
		$HBoxContainer/VBoxContainer/Resources.add_child(info_instance)

	
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
	
	for info in anomaly.mechanics_info:
		var info_instance = info_scene.instantiate()
		info_instance.text = info
		$HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer.add_child(info_instance)
	
	$HBoxContainer/VBoxContainer3/EscapeStats.text = str(anomaly.damage_res_phys) + " " + str(anomaly.damage_res_ment)
	
	if anomaly.weapon_open:
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.hide()
		$HBoxContainer/VBoxContainer3/Shop/Weapon.show()
		$HBoxContainer/VBoxContainer3/BuyButtons/BuyWeapon.show()
	else:
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.text = "Open: " + str(equip_cost)
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.show()
		$HBoxContainer/VBoxContainer3/Shop/Weapon.hide()
		$HBoxContainer/VBoxContainer3/BuyButtons/BuyWeapon.hide()
		
	if anomaly.armor_open:
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.hide()
		$HBoxContainer/VBoxContainer3/Shop/Armor.show()
		$HBoxContainer/VBoxContainer3/BuyButtons/BuyArmor.show()
	else:
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.text = "Open: " + str(equip_cost)
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.show()
		$HBoxContainer/VBoxContainer3/Shop/Armor.hide()
		$HBoxContainer/VBoxContainer3/BuyButtons/BuyArmor.hide()
		
	self.show()
