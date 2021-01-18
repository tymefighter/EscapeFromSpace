extends Node2D

export var damage : int = 1
var velocity : Vector2 = Vector2.ZERO
	
func _process(delta):
	position += velocity * delta

func get_velocity():
	return velocity

func set_velocity(new_velocity : Vector2):
	velocity = new_velocity

func _on_Area2D_body_entered(body):

	if body.get("health"):
		body.health -= damage
	
	queue_free()
