extends "res://Scripts/Base_Classes/Base_Character.gd"

onready var player = get_node("../../../Player")
onready var nav2d = get_node("../../../Navigation2D")
onready var enemy_manager = get_parent().get_parent()
onready var extents = $CollisionShape2D.get_shape().get_extents()

export var max_sight_distance: int = 100
export var min_flock_dist = 40


var path : = PoolVector2Array()


var separation_weight = 0.4
var chase_weight = 1

func _ready(): 
	max_speed = 75
	reset_speed()
	set_collision_layer_bit(2, true)
	
func _physics_process(_delta):
	if enemy_manager.player_detected == false:
		if dist_to_player() <= max_sight_distance:
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
			if result.collider.is_in_group("Player"):
				enemy_manager.player_detected = true	

		
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

func death():
	.death()
	self.queue_free()
