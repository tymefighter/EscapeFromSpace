extends KinematicBody2D

const MAX_SPEED = 200
const FRICTION = 1000
const ACCELERATION = 50
var velocity = Vector2.ZERO
var weapon = null
var health = 400
var armour = 0

onready var animationPlayer = get_node("PlayerRight/AnimationPlayer")

func _process(delta):
	var health_label = get_node("HealthLabel")
	if health_label != null:
		health_label.text = str(health)
		
	var ammo_label = get_node("AmmoLabel")
	if ammo_label != null:
		if weapon != null:
			ammo_label.text = str(weapon.ammo)
		else:
			ammo_label.text = "0"
			
	var armour_label = get_node("ArmourLabel")
	if armour_label != null:
		armour_label.text = str(armour)
		
	if health <= 0:
		get_tree().change_scene("res://UI/LoseScreen.tscn")

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
			animationPlayer = get_node("PlayerBack/AnimationPlayer")
			animationPlayer.play("BackVertical")
			get_node("PlayerRight").hide()
			get_node("PlayerFront").hide()
			get_node("PlayerLeft").hide()
			get_node("PlayerBack").show()
		elif(input_vector.y > 0):
			animationPlayer = get_node("PlayerFront/AnimationPlayer")
			animationPlayer.play("FrontVertical")
			get_node("PlayerRight").hide()
			get_node("PlayerLeft").hide()
			get_node("PlayerBack").hide()
			get_node("PlayerFront").show()
		elif(input_vector.x > 0):
			animationPlayer = get_node("PlayerRight/AnimationPlayer")
			animationPlayer.play("RightHorizontal")
			get_node("PlayerFront").hide()
			get_node("PlayerLeft").hide()
			get_node("PlayerBack").hide()
			get_node("PlayerRight").show()
		elif(input_vector.x < 0):
			animationPlayer = get_node("PlayerLeft/AnimationPlayer")
			animationPlayer.play("LeftHorizontal")
			get_node("PlayerFront").hide()
			get_node("PlayerBack").hide()
			get_node("PlayerRight").hide()
			get_node("PlayerLeft").show()
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
