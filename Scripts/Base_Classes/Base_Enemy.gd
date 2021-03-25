extends "res://Scripts/Base_Classes/Base_Character.gd"

onready var player = get_node("../Player")

export var max_sight_distance: int = 150
export var max_chase_distance: int = 300
export var stopping_distance: int = 50

var chasing = false
var stopping_rate = .2

func _ready():
	max_speed = 75
	reset_speed()
	set_collision_layer_bit(2, true)

func _physics_process(delta):
	#This ai logic is trash
	if self.global_position.distance_to(player.global_position) <= max_sight_distance and self.global_position.distance_to(player.global_position) >= stopping_distance:
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
