extends Area2D

@export var highlight: Control

func _on_mouse_entered() -> void:
	highlight.visible = true


func _on_mouse_exited() -> void:
	highlight.visible = false
