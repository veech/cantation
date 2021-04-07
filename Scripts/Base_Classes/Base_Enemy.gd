extends "res://Scripts/Base_Classes/Base_Character.gd"

onready var player = get_node("../../../Player")
onready var nav2d = get_node("../../../Navigation2D")
onready var enemy_manager = get_parent().get_parent()
onready var extents = $CollisionShape2D.get_shape().get_extents()

export var max_sight_distance: int = 100
export var min_flock_dist = 40

export var casting_range_min = 70
export var casting_range_max = 120

var path : = PoolVector2Array()

var separation_weight = 0.4
var chase_weight = 1

var in_casting_range = false
var cast_speed = 1.5
var cast_timer

signal casting_range
signal out_of_range

func _ready(): 
	max_speed = 75
	reset_speed()
	layer = 2
	set_collision_layer_bit(layer, true)
	
	cast_timer = Timer.new()
	add_child(cast_timer)
	cast_timer.set_one_shot(true)
	cast_timer.set_wait_time(cast_speed)	
	cast_timer.connect("timeout", self, "cast_spell")
	connect("casting_range", self, "cast_spell")
	connect("out_of_range", self, "cease_casting")
	
#func _physics_process(_delta):
#	if enemy_manager.player_detected == false and dist_to_player() <= max_sight_distance:
#		var space_state = get_world_2d().direct_space_state
#		var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
#		if result.collider.is_in_group("Player"):
#			enemy_manager.player_detected = true	
#	else:
#		var space_state = get_world_2d().direct_space_state
#		var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
#		if !result.collider.is_in_group("Player"):
#			in_casting_range = false

func _physics_process(delta):
	var distance = dist_to_player()
	if enemy_manager.player_detected == false:
		if distance <= max_sight_distance:
			var space_state = get_world_2d().direct_space_state
			var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
			if result.collider.is_in_group("Player"):
				enemy_manager.player_detected = true
				emit_signal("casting_range")
				in_casting_range = true
				velocity = Vector2.ZERO
	elif enemy_manager.player_detected == true:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
		if result.size() > 0:
			if !result.collider.is_in_group("Player"):
				emit_signal("out_of_range")
				in_casting_range = false		
			elif result.collider.is_in_group("Player"):
				if distance >= casting_range_max and in_casting_range: # and enemy_manager.player_detected == true:
					emit_signal("out_of_range")
					in_casting_range = false
				elif distance <= casting_range_max and !in_casting_range:
					emit_signal("casting_range")
					in_casting_range = true		
				elif distance <= casting_range_min:
					velocity = Vector2.ZERO

func get_name():
	return enemy_manager.get_name()

func equip_spell(spell):
	var new_spell = spell.new()
	add_child(new_spell)
	equipped_spells.push_back(new_spell)
	equipped_spells[0].randomize_attributes()
	equipped_spells[0].attributes["caster"] = enemy_manager.get_name()

func calculate_goal():
	var separation = calc_separate() * separation_weight
	var player_path = calc_targeting() * chase_weight
	velocity =  Vector2(separation + player_path).normalized()

func calc_separate():
	var separate = Vector2()
	for enemy in enemy_manager.enemies:
		if enemy != null:
			var distance = global_position.distance_to(enemy.global_position)
			if distance > 0 and distance <= 40:
				var difference = (global_position - enemy.global_position)
				separate += difference.normalized()/distance
	return separate

func calc_targeting():
	if !in_casting_range:
		var path = nav2d.get_simple_path(global_position, player.global_position, false)
		return path[1] - global_position
	else:
		return Vector2.ZERO

func cast_spell():
	if can_shoot and shocked == false:
		equipped_spells[0].cast(self, player.position)
		cast_timer.start()
	
#This should stop the timer
func cease_casting():
	cast_timer.stop()

func dist_to_player():
	return self.global_position.distance_to(player.global_position)		

func take_damage(damage):
	.take_damage(damage)
	if !enemy_manager.player_detected:
		enemy_manager.player_detected = true

func death():
	.death()
	self.queue_free()
