extends Node2D

func _ready():
	pass
	
func _process(delta):
	if get_node("YSort/FinalBoss1") == null and get_node("YSort/FinalBoss2") == null:
		get_tree().change_scene("res://UI/WinScreen.tscn")
