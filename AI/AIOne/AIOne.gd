extends KinematicBody2D

const MAX_SPEED = 90
const FRICTION = 1000
const ACCELERATION = 20
var velocity = Vector2.ZERO
var weapon_scene = load("res://Items/Weapons/Guns/Epsilon/Epsilon.tscn")
var weapon = null
var health = 1000
var player = null

func _process(delta):
	if weapon == null:
		weapon = weapon_scene.instance()
		weapon.global_scale *= 0.3
		weapon.dist_to_gun = 20
		add_child(weapon)
		
	if health <= 0:
		queue_free()

func _physics_process(delta):
	
	if player != null:
		
		if weapon != null:
			weapon.shoot(delta)
	
		var input_vector = player.position - position
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			
			if(input_vector.y < 0):
				get_node("OneRight").hide()
				get_node("OneFront").hide()
				get_node("OneLeft").hide()
				get_node("OneBack").show()
			elif(input_vector.y > 0):
				get_node("OneRight").hide()
				get_node("OneLeft").hide()
				get_node("OneBack").hide()
				get_node("OneFront").show()
			elif(input_vector.x > 0):
				get_node("OneFront").hide()
				get_node("OneLeft").hide()
				get_node("OneBack").hide()
				get_node("OneRight").show()
			elif(input_vector.x < 0):
				get_node("OneRight").hide()
				get_node("OneFront").hide()
				get_node("OneBack").hide()
				get_node("OneLeft").show()
			velocity += input_vector * ACCELERATION
			velocity = velocity.clamped(MAX_SPEED)
			
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
		velocity = move_and_slide(velocity)

func get_weapon():
	return weapon
	
func set_weapon(new_weapon):
	weapon = new_weapon

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		player = body
