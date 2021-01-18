extends KinematicBody2D

const MAX_SPEED = 100
const FRICTION = 1000
const ACCELERATION = 50
var velocity = Vector2.ZERO
var health = 600
var min_dist_to_player = 100
var player = null

onready var weapon = get_node("Weapon")
onready var animationPlayer = get_node("AnimationPlayer")
onready var k = "D"

func _ready():
	weapon.update_pos_parent(
		Vector2(8, 3),
		Vector2(-8, 3),
		Vector2(8, 3),
		Vector2(-8, 3)
	)

func _process(delta):
		
	if health <= 0:
		queue_free()

func _physics_process(delta):

	if player != null:
		
		if weapon != null:
			weapon.shoot(delta)
	
		var input_vector : Vector2 = player.position - position
		
		if input_vector.length() <= min_dist_to_player:
			input_vector = Vector2.ZERO
		else:
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

func _on_Area2D_body_entered(body):
	
	if body.name == 'Player':
		player = body
