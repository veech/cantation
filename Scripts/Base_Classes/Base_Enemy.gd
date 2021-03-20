extends "res://Scripts/Base_Classes/Base_Character.gd"


onready var player = get_node("../Player")

export var max_sight_distance: int = 150
export var max_chase_distance: int
export var stopping_distance: int = 50

var chasing = false
var stopping_rate = .2


func _physics_process(delta):
	# this raycast needs to ignore NPCs
	if self.global_position.distance_to(player.global_position) <= max_sight_distance and self.global_position.distance_to(player.global_position) >= stopping_distance:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, player.global_position, [self])
		if result.collider.is_in_group("Player"):
			chasing = true
		else:
			chasing = false
	elif self.global_position.distance_to(player.global_position) <= stopping_distance:
		chasing = false
	if chasing == true:
		velocity = direction_from_to(self.global_position, player.global_position)
	else:
		velocity = lerp(velocity, Vector2.ZERO, stopping_rate)
func direction_from_to(position_a, position_b):
	var direction = position_b - position_a
	return direction.normalized()
