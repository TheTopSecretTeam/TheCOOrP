extends Node

func _ready() -> void:
	$Button.process_mode = Node.PROCESS_MODE_ALWAYS
	# Более безопасное подключение сигнала с проверкой
	$Button.pressed.connect(_on_return_button_pressed)

func _on_return_button_pressed() -> void:
	print("Return button pressed!")

	var current_scene = get_tree().current_scene  # Сохраняем текущую сцену

	# Удаляем все дочерние узлы корня, кроме текущей сцены
	for child in get_tree().root.get_children():
		if child != current_scene and child != Global:  # Не удаляем текущую сцену
			child.queue_free()

	get_tree().paused = false
	Global._reset()
	# Теперь можно безопасно загрузить новую сцену
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
