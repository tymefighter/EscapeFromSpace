extends KinematicBody2D

const MAX_SPEED = 200
const FRICTION = 1000
const ACCELERATION = 50
var velocity = Vector2.ZERO
var weapon = null
var health = 400

onready var animationPlayer = get_node("TwoFront/AnimationPlayer")

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
			animationPlayer = get_node("TwoBack/AnimationPlayer")
			animationPlayer.play("BackVertical")
			get_node("TwoRight").hide()
			get_node("TwoFront").hide()
			get_node("TwoLeft").hide()
			get_node("TwoBack").show()
		elif(input_vector.y > 0):
			animationPlayer = get_node("TwoFront/AnimationPlayer")
			animationPlayer.play("FrontVertical")
			get_node("TwoRight").hide()
			get_node("TwoLeft").hide()
			get_node("TwoBack").hide()
			get_node("TwoFront").show()
		elif(input_vector.x > 0):
			animationPlayer = get_node("TwoRight/AnimationPlayer")
			animationPlayer.play("RightHorizontal")
			get_node("TwoFront").hide()
			get_node("TwoLeft").hide()
			get_node("TwoBack").hide()
			get_node("TwoRight").show()
		elif(input_vector.x < 0):
			animationPlayer = get_node("TwoLeft/AnimationPlayer")
			animationPlayer.play("LeftHorizontal")
			get_node("TwoRight").hide()
			get_node("TwoFront").hide()
			get_node("TwoBack").hide()
			get_node("TwoLeft").show()
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_SPEED)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationPlayer.play("Idle")
		
	velocity = move_and_slide(velocity)

func get_weapon():
	return weapon
	
func set_weapon(new_weapon):
	weapon = new_weapon
