extends Node2D

# Bullet Scene
export var bullet_scene_path = \
	"res://Items/Weapons/Bullets/DefaultBullet/DefaultBullet.tscn"
onready var bullet_scene : Resource = load(bullet_scene_path)

# Gun Stats
export var initial_ammo : int = 100
export var bullet_scale : Vector2 = Vector2(0.5, 0.5) # bullet scale with respect to gun
export var dist_bullet_gun = 0		# distance between bullet and gun
export var bullet_speed = 500		# bullet speed
export var fire_rate = 5 			# bullets per second
onready var time_gap = 1.0 / fire_rate

# Position of gun With respect to the parent
# when the gun is oriented in a specific direction
var pos_gun_right : Vector2 = Vector2(50, -10)
var pos_gun_left : Vector2 = Vector2(-50, -10)
var pos_gun_up : Vector2 = Vector2(50, -10)
var pos_gun_down : Vector2 = Vector2(-50, -10)

# Previous global position of the gun
var prev_global_position : Vector2 = Vector2.ZERO

# Current gun information
var gun_direction : String = "right"
var curr_gap : float = 0.0
onready var ammo : int = initial_ammo

# Is player inside gun area2d
var player_node = null
	
func pick_weapon_if_req():
	
	if player_node != null and Input.is_key_pressed(KEY_G):
		var temp_player_node = player_node
		var self_global_scale = global_scale
		var self_global_position = global_position
		
		var parent_node = get_parent()
		parent_node.remove_child(self)
		
		var curr_held_weapon = temp_player_node.get_weapon()
		
		if curr_held_weapon != null:
			var curr_held_weapon_global_scale = curr_held_weapon.get_global_scale()
			temp_player_node.remove_child(curr_held_weapon)
			parent_node.add_child(curr_held_weapon)
			curr_held_weapon.set_global_position(self_global_position)
			curr_held_weapon.set_global_scale(curr_held_weapon_global_scale)
		
		# Set new weapon
		temp_player_node.add_child(self)
		global_scale = self_global_scale
		temp_player_node.set_weapon(self)

func update_weapon_pos_for_player():
	
	var parent_node : Node2D = get_parent()
	
	if (
		parent_node.get("weapon") != null
		and global_position != prev_global_position
	):
		var direction_vector = global_position - prev_global_position
		
		if(abs(direction_vector.x) >= abs(direction_vector.y)):
			get_node("Sprite").rotation_degrees = 0
			
			if direction_vector.x >= 0:
				gun_direction = 'right'
				position = pos_gun_right
				get_node("Sprite").flip_h = false
				
			else:
				gun_direction = 'left'
				position = pos_gun_left
				get_node("Sprite").flip_h = true
		else:
			get_node("Sprite").flip_h = false
			
			if direction_vector.y <= 0:
				gun_direction = 'up'
				position = pos_gun_up
				get_node("Sprite").rotation_degrees = 270
				
			else:
				gun_direction = 'down'
				position = pos_gun_down
				get_node("Sprite").rotation_degrees = 90
				
		prev_global_position = global_position

func destroy_if_ammo_empty():
	
	if ammo <= 0:
		# If Ammo is over, destroy the weapon
		
		var parent_node : Node2D = get_parent()
		if parent_node.has_method("set_weapon"):
			parent_node.set_weapon(null)
			
		queue_free()

func _process(delta):
	
	pick_weapon_if_req()
	update_weapon_pos_for_player()
	destroy_if_ammo_empty()
	
func shoot(delta):
	""" Shoot bullets """
	
	# Get gun direction vector
	var gun_direction_vector : Vector2 = Vector2.ZERO
	match gun_direction:
		'right': gun_direction_vector.x = 1
		'left': gun_direction_vector.x = -1
		'up': gun_direction_vector.y = -1
		'down': gun_direction_vector.y = 1
	
	# Get velocity
	var velocity = bullet_speed * gun_direction_vector
	
	# Get root of current scene
	var current_scene_root = get_tree().get_current_scene()
	
	# Shoot out the required number of bullets
	curr_gap += delta
	while curr_gap >= time_gap:
	
		var bullet : Node2D = bullet_scene.instance()
		current_scene_root.add_child(bullet)
		
		bullet.set_global_scale(bullet_scale)
		bullet.set_global_position(
			global_position + dist_bullet_gun * gun_direction_vector
		)
		bullet.set_velocity(velocity)
		
		curr_gap -= time_gap
		ammo -= 1

func update_pos_parent(
	new_pos_gun_right : Vector2 = Vector2(50, -10),
	new_pos_gun_left : Vector2 = Vector2(-50, -10),
	new_pos_gun_up : Vector2 = Vector2(50, -10),
	new_pos_gun_down : Vector2 = Vector2(-50, -10)
):
	pos_gun_right = new_pos_gun_right
	pos_gun_left = new_pos_gun_left
	pos_gun_up = new_pos_gun_up
	pos_gun_down = new_pos_gun_down
	
func get_ammo():
	return ammo	
	
func _on_Area2D_body_entered(body):
		
	if body.name == 'Player':
		player_node = body

func _on_Area2D_body_exited(body):
	if body.name == 'Player':
		player_node = null
