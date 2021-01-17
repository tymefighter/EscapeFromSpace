extends KinematicBody2D

const MAX_SPEED = 100
const FRICTION = 1000
const ACCELERATION = 30
var velocity = Vector2.ZERO
var weapon_scene = load("res://Items/Weapons/Guns/Night/Night.tscn")
var weapon = null
var health = 200
var player = null

onready var animationPlayer = get_node("AnimationPlayer")
onready var k = "D"

func _process(delta):
	if weapon == null:
		weapon = weapon_scene.instance()
		weapon.global_scale *= 0.2
		weapon.dist_to_gun = 10
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
				animationPlayer = get_node("AnimationPlayer")
				animationPlayer.play("RunUp")
				k = "U"
			elif(input_vector.y > 0):
				animationPlayer = get_node("AnimationPlayer")
				animationPlayer.play("RunDown")
				k = "D"
			elif(input_vector.x > 0):
				animationPlayer = get_node("AnimationPlayer")
				animationPlayer.play("RunRight")
				k = "R"
			elif(input_vector.x < 0):
				animationPlayer = get_node("AnimationPlayer")
				animationPlayer.play("RunLeft")
				k = "L"
			velocity += input_vector * ACCELERATION
			velocity = velocity.clamped(MAX_SPEED)
			
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if(k == "U"):
				animationPlayer.play("IdleUp")
			elif(k == "D"):
				animationPlayer.play("IdleDown")
			elif(k == "R"):
				animationPlayer.play("IdleRight")
			elif(k == "L"):
				animationPlayer.play("IdleLeft")
			
		velocity = move_and_slide(velocity)

func get_weapon():
	return weapon
	
func set_weapon(new_weapon):
	weapon = new_weapon

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		player = body
