extends KinematicBody2D

const MAX_SPEED = 200
const FRICTION = 1000
const ACCELERATION = 50
var velocity = Vector2.ZERO
var weapon = null
var health = 400


func _physics_process(delta):

	if Input.is_key_pressed(KEY_P) and weapon != null:
		weapon.shoot(delta)

	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_key_d") \
		- Input.get_action_strength("ui_key_a")

	input_vector.y = Input.get_action_strength("ui_key_s") \
		- Input.get_action_strength("ui_key_w")
	
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
