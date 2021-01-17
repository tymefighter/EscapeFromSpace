extends Control

func _ready():
	get_node("Timer").start()

func _on_Timer_timeout():
	get_tree().change_scene("res://UI/TitleScreen.tscn")
