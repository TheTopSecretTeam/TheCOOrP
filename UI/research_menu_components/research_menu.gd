extends TabContainer
var anomaly : AbnormalityResource

func _on_open_weapon_button_down() -> void:
	if anomaly.unique_pe < anomaly.weapon_cost: return
	anomaly.unique_pe -= anomaly.weapon_cost
	anomaly.weapon_open = true
	$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.hide()
	$HBoxContainer/VBoxContainer3/Shop/Weapon.show()
	$HBoxContainer/VBoxContainer3/BuyButtons/BuyWeapon.show()
	

func _on_open_armor_button_down() -> void:
	if anomaly.unique_pe < anomaly.armor_cost: return
	anomaly.unique_pe -= anomaly.armor_cost
	anomaly.armor_open = true
	$HBoxContainer/VBoxContainer3/Shop/OpenArmor.hide()
	$HBoxContainer/VBoxContainer3/Shop/Armor.show()
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

func _on_exit_button_down() -> void:
	hide()

func window_call(res: AbnormalityResource) -> void:
	anomaly = res
	
	$HBoxContainer/VBoxContainer/Unique_PE.text = "PE: " + str(anomaly.unique_pe)
	$HBoxContainer/VBoxContainer/Name.text = anomaly.monster_name
	$HBoxContainer/VBoxContainer/TextureRect.texture = anomaly.profile
	
	$HBoxContainer/VBoxContainer2/GridContainer/work1/VBoxContainer/TextureRect.texture = anomaly.works[0].icon
	$HBoxContainer/VBoxContainer2/GridContainer/work2/VBoxContainer/TextureRect.texture = anomaly.works[1].icon
	$HBoxContainer/VBoxContainer2/GridContainer/work3/VBoxContainer/TextureRect.texture = anomaly.works[2].icon
	$HBoxContainer/VBoxContainer2/GridContainer/work4/VBoxContainer/TextureRect.texture = anomaly.works[3].icon
	
	$HBoxContainer/VBoxContainer2/GridContainer/work1/Label.text = str(anomaly.works[0].probabilty * 100) + "%"
	$HBoxContainer/VBoxContainer2/GridContainer/work2/Label.text = str(anomaly.works[1].probabilty * 100) + "%"
	$HBoxContainer/VBoxContainer2/GridContainer/work3/Label.text = str(anomaly.works[2].probabilty * 100) + "%"
	$HBoxContainer/VBoxContainer2/GridContainer/work4/Label.text = str(anomaly.works[3].probabilty * 100) + "%"
	
	$HBoxContainer/VBoxContainer2/GridContainer/work1/VBoxContainer/Label.text = anomaly.works[0].button_text
	$HBoxContainer/VBoxContainer2/GridContainer/work2/VBoxContainer/Label.text = anomaly.works[1].button_text
	$HBoxContainer/VBoxContainer2/GridContainer/work3/VBoxContainer/Label.text = anomaly.works[2].button_text
	$HBoxContainer/VBoxContainer2/GridContainer/work4/VBoxContainer/Label.text = anomaly.works[3].button_text

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
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.text = "Purchase: " + str(anomaly.weapon_cost)
		$HBoxContainer/VBoxContainer3/Shop/OpenWeapon.show()
		$HBoxContainer/VBoxContainer3/Shop/Weapon.hide()
		$HBoxContainer/VBoxContainer3/BuyButtons/BuyWeapon.hide()
		
	if anomaly.armor_open:
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.hide()
		$HBoxContainer/VBoxContainer3/Shop/Armor.show()
		$HBoxContainer/VBoxContainer3/BuyButtons/BuyArmor.show()
	else:
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.text = "Purchase: " + str(anomaly.armor_cost)
		$HBoxContainer/VBoxContainer3/Shop/OpenArmor.show()
		$HBoxContainer/VBoxContainer3/Shop/Armor.hide()
		$HBoxContainer/VBoxContainer3/BuyButtons/BuyArmor.hide()
		
	self.show()
