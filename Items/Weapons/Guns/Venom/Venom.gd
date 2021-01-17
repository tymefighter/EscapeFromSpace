extends Node2D

onready var prev_parent_position = Vector2.ZERO
var gun_direction = 'right'

var bullet_scene = \
	load("res://Items/Weapons/Bullets/VenomBullet/VenomBullet.tscn")
	
const dist_to_gun = 40
const bullet_speed = 900
const fire_rate = 2 # Bullets Per Second
const time_gap = 1.0 / fire_rate
var curr_gap = 0.0
var ammo = 20

func _ready():
	pass
	
func _process(delta):
	
	if get_parent().has_method("get_weapon") and get_parent().position != prev_parent_position:
		var direction_vector = get_parent().position - prev_parent_position
		
		if(abs(direction_vector.x) >= abs(direction_vector.y)):
			get_node("Sprite").rotation_degrees = 0
			
			if direction_vector.x >= 0:
				gun_direction = 'right'
				position = Vector2(dist_to_gun, 0)
				get_node("Sprite").flip_h = false
			else:
				gun_direction = 'left'
				position = Vector2(-dist_to_gun, 0)
				get_node("Sprite").flip_h = true
		else:
			get_node("Sprite").flip_h = false
			
			if direction_vector.y <= 0:
				gun_direction = 'up'
				position = Vector2(dist_to_gun, -dist_to_gun)
				get_node("Sprite").rotation_degrees = 270
				
			else:
				gun_direction = 'down'
				position = Vector2(-dist_to_gun, dist_to_gun)
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
		bullet.scale = 0.4 * scale
		bullet.position = 0.3 * position + get_parent().position
		bullet.velocity = velocity
		current_scene_root.add_child(bullet)
		
		curr_gap -= time_gap
		
		ammo -= 1

func _on_Area2D_body_entered(body):
	if body.has_method("get_weapon"):
		if Input.is_key_pressed(KEY_G):
			
			var self_scale_in_world = scale
			var self_position_in_world = position
			
			var parent_node = get_parent()
			parent_node.remove_child(self)
			
			var curr_held_weapon = body.get_weapon()
			
			if curr_held_weapon != null:
				body.remove_child(curr_held_weapon)
				parent_node.add_child(curr_held_weapon)
				curr_held_weapon.scale = self_scale_in_world
				curr_held_weapon.position = self_position_in_world
			
			# Add New Weapon
			body.set_weapon(self)
			body.add_child(self)
			scale /= body.scale
