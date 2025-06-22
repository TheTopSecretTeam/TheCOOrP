extends Control

func _on_Main_NewGame_pressed():
	$Main.hide()
	$NewGameMenu.show()

func _on_Main_Load_pressed():
	$Main.hide()
	$LoadMenu.show()

func _on_Main_Settings_pressed():
	print("Settings are not implemented")

func _on_Main_Join_pressed():
	print("Join is not implemented")

func _on_Main_Exit_pressed():
	$ExitDialog.popup_centered()

func _on_Main_Exit_confirmed():
	get_tree().quit()

func _on_Load_NewWorld_pressed():
	print("New World is not implemented")

func _on_Load_Back_pressed():
	$LoadMenu.hide()
	$Main.show()

func _on_NG_Back_pressed():
	$NewGameMenu.hide()
	$Main.show()

func _on_NG_Start_pressed():
	pass
