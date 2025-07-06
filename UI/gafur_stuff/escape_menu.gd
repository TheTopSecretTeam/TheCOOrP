extends Control

# Inspired by this video https://youtu.be/JEQR4ALlwVU

func _on_resume_pressed():
	visible = false

func _on_quit_pressed():
	pass
	#get_tree().quit() # TODO Gracefully quit the level
