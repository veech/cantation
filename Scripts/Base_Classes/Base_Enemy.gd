extends "res://Scripts/Base_Classes/Base_Character.gd"

onready var player = get_node("../../../Player")
onready var nav2d = get_node("../../../Navigation2D")
#onready var line2d = get_node("../../Line2D")
onready var enemy_manager = get_parent().get_parent()
onready var extents = $CollisionShape2D.get_shape().get_extents()
#onready var animated_sprite = $AnimatedSprite

export var max_sight_distance: int = 100
export var min_flock_dist = 40

var path : = PoolVector2Array()
var chasing = false
var stopping_rate = .2

var separation_weight = 0.4
var chase_weight = 1



func _ready(): 
	max_speed = 75
	reset_speed()
	set_collision_layer_bit(2, true)
	#animated_sprite.play("Idle_Down")
	
func _physics_process(_delta):
	if enemy_manager.player_detected == false:
		if dist_to_player() <= max_sight_distance:
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
			if result.collider.is_in_group("Player"):
				enemy_manager.player_detected = true	
	#animator(velocity)

func animator(direction: Vector2):
	if direction != Vector2.ZERO:
		animated_sprite.play("Walk_" + get_animation_direction(direction))
	else:
		animated_sprite.stop()

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "Down"
	elif norm_direction.y <= -0.707:
		return "Up"
	elif norm_direction.x <= -0.707:
		return "Left"
	elif norm_direction.x >= 0.707:
		return "Right"
	return "Down"	

func calculate_goal():
	var separation = calc_separate() * separation_weight
	var player_path = calc_targeting() * chase_weight
	velocity =  Vector2(separation + player_path).normalized()
	
func calc_targeting():
	var path = nav2d.get_simple_path(global_position, player.global_position, false)
	return path[1] - global_position
			
func calc_separate():
	var separate = Vector2()
	for enemy in enemy_manager.enemies:
		if enemy != null:
			var distance = global_position.distance_to(enemy.global_position)
			if distance > 0 and distance <= 40:
				var difference = (global_position - enemy.global_position)
				separate += difference.normalized()/distance
	return separate
		
func dist_to_player():
	
	return self.global_position.distance_to(player.global_position)		

func direction_from_to(position_a, position_b):
	var direction = position_b - position_a
	return direction.normalized()

func death():
	.death()
	self.queue_free()
