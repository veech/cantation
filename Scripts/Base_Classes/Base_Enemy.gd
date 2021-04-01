extends "res://Scripts/Base_Classes/Base_Character.gd"

onready var player = get_node("../../../Player")
onready var nav2d = get_node("../../../Navigation2D")
#onready var line2d = get_node("../../Line2D")
onready var enemy_manager = get_parent().get_parent()
onready var extents = $CollisionShape2D.get_shape().get_extents()

export var max_sight_distance: int = 150
export var max_chase_distance: int = 300
export var stopping_distance: int = 50
export var min_flock_dist = 40

var path : = PoolVector2Array()
var chasing = false
var stopping_rate = .2

var separation_weight = 10
var chase_weight = 1

func _ready(): 
	max_speed = 75
	reset_speed()
	set_collision_layer_bit(2, true)

func _unhandled_input(event):
	if event.is_action_pressed("Cast"):
		print(velocity)		

func calculate_goal():
	var separation = calc_separate() * separation_weight
	var player_path = better_chase() * chase_weight
	velocity =  Vector2(separation + player_path).normalized()
	
func better_chase():
	if dist_to_player() <= max_sight_distance and dist_to_player() >= stopping_distance:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
		if result.collider.is_in_group("Player"):
			chasing = true	
	if chasing:
		var path = nav2d.get_simple_path(global_position, player.global_position, false)
#		line2d.points = path
		return path[1] - global_position
	else:
		return Vector2.ZERO
		
		
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

func simple_chase(delta):
		#This ai logic is trash
	if dist_to_player() <= max_sight_distance and dist_to_player() >= stopping_distance:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
		if result.collider.is_in_group("Player"):
			chasing = true
		else:
			chasing = false
	elif self.global_position.distance_to(player.global_position) <= stopping_distance or self.global_position.distance_to(player.global_position) >= max_chase_distance:
		chasing = false
	if chasing == true:
		velocity = direction_from_to(self.global_position, player.global_position)
	else:
		velocity = lerp(velocity, Vector2.ZERO, stopping_rate)

func direction_from_to(position_a, position_b):
	var direction = position_b - position_a
	return direction.normalized()

func death():
	.death()
	self.queue_free()
