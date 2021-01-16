extends Node2D

onready var prev_parent_position = Vector2.ZERO
var gun_direction = 'right'

var bullet_scene = \
	load("res://Items/Weapons/Bullets/VenomBullet/VenomBullet.tscn")
const bullet_speed = 900
const fire_rate = 2 # Bullets Per Second
const time_gap = 1.0 / fire_rate
var curr_gap = 0.0
var ammo = 20

func _ready():
	pass
	
func _process(delta):
	
	if get_parent().position != prev_parent_position:
		var direction_vector = get_parent().position - prev_parent_position
		
		if(abs(direction_vector.x) >= abs(direction_vector.y)):
			get_node("Sprite").rotation_degrees = 0
			
			if direction_vector.x >= 0:
				gun_direction = 'right'
				position = Vector2(50, 0)
				get_node("Sprite").flip_h = false
			else:
				gun_direction = 'left'
				position = Vector2(-50, 0)
				get_node("Sprite").flip_h = true
		else:
			get_node("Sprite").flip_h = false
			
			if direction_vector.y <= 0:
				gun_direction = 'up'
				position = Vector2(0, -50)
				get_node("Sprite").rotation_degrees = 270
				
			else:
				gun_direction = 'down'
				position = Vector2(0, 50)
				get_node("Sprite").rotation_degrees = 90
				
		prev_parent_position = get_parent().position
		
	if ammo <= 0:
		var parent_node = get_parent()
		if parent_node.has_method("set_weapon"):
			parent_node.set_weapon(null)
			
		queue_free()
	
func shoot(delta):
	var velocity = Vector2.ZERO
	
	match gun_direction:
		'right': velocity.x = 1
		'left': velocity.x = -1
		'up': velocity.y = -1
		'down': velocity.y = 1
		
	velocity *= bullet_speed
	
	var current_scene_root = get_tree().get_current_scene()
	
	curr_gap += delta
	
	while curr_gap >= time_gap:
	
		var bullet = bullet_scene.instance()
		bullet.position = 2 * position + get_parent().position
		bullet.velocity = velocity
		current_scene_root.add_child(bullet)
		
		curr_gap -= time_gap
		
		ammo -= 1

func _on_Area2D_body_entered(body):
	if body.has_method("get_weapon"):
		if Input.is_key_pressed(KEY_G):
			
			# Delete Current Weapon
			var curr_weapon = body.get_weapon()
			
			if curr_weapon != null:
				body.remove_child(curr_weapon)
				curr_weapon.queue_free()
			
			# Remove Placed Weapon
			get_parent().remove_child(self)
			
			# Add New Weapon
			body.set_weapon(self)
			body.add_child(self)
