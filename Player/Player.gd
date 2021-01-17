extends KinematicBody2D

var weapon = null
var health = 400
const SPEED = 100

func _ready():
	pass
	
func _process(delta):
	
	var velocity = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_W):
		velocity.y = -1
	if Input.is_key_pressed(KEY_S):
		velocity.y += 1
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1
	if Input.is_key_pressed(KEY_D):
		velocity.x += 1
		
	if Input.is_key_pressed(KEY_P) and weapon != null:
		weapon.shoot(delta)
		
	velocity *= SPEED
	move_and_slide(velocity)
	
func get_weapon():
	return weapon
	
func set_weapon(new_weapon):
	weapon = new_weapon
