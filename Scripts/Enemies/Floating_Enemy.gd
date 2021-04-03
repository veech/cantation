extends "res://Scripts/Base_Classes/Base_Enemy.gd"

export var casting_range_min = 70
export var casting_range_max = 120

var in_casting_range = false
var cast_speed = 1.5
var cast_timer

signal casting_range
signal out_of_range

func _ready():
	cast_timer = Timer.new()
	add_child(cast_timer)
	cast_timer.set_one_shot(true)
	cast_timer.set_wait_time(cast_speed)	
	cast_timer.connect("timeout", self, "cast_spell")
	connect("casting_range", self, "cast_spell")
	connect("out_of_range", self, "cease_casting")
	
func _physics_process(delta):
	var distance = dist_to_player()
	
	# signal is 
	
	if enemy_manager.player_detected == false:
		if dist_to_player() <= max_sight_distance:
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
			if result.collider.is_in_group("Player"):
				enemy_manager.player_detected = true
				emit_signal("casting_range")
				in_casting_range = true
				velocity = Vector2.ZERO

	elif distance >= casting_range_max: # and enemy_manager.player_detected == true:
		emit_signal("out_of_range")
		in_casting_range = false
	if distance <= casting_range_min and !in_casting_range:
		emit_signal("casting_range")
		in_casting_range = true
		velocity = Vector2.ZERO

func calc_targeting():
	if !in_casting_range:
		var path = nav2d.get_simple_path(global_position, player.global_position, false)
		return path[1] - global_position
	else:
		return Vector2.ZERO

#This should start a timer
func cast_spell():
	print("FIRE")
	cast_timer.start()
	
#This should stop the timer
func cease_casting():
	cast_timer.stop()
