extends Node2D

var damage = 14
var velocity = Vector2.ZERO

func _ready():
	pass
	
func _process(delta):
	position += velocity * delta

func _on_Area2D_body_entered(body):
	
	if body.get("health"):
		body.health -= damage
	
	queue_free()
