extends "res://Scripts/Base_Classes/Base_Enemy.gd"

func _ready():
	casting_range_min = 70
	casting_range_max = 120
	equip_spell(Fireball_Launcher)
	
#func _physics_process(delta):
#	var distance = dist_to_player()
#
#	if enemy_manager.player_detected == false:
#		if dist_to_player() <= max_sight_distance:
#			var space_state = get_world_2d().direct_space_state
#			var result = space_state.intersect_ray(global_position, player.global_position, [self], 0b1010)
#			if result.collider.is_in_group("Player"):
#				enemy_manager.player_detected = true
#				emit_signal("casting_range")
#				in_casting_range = true
#				velocity = Vector2.ZERO
#
#	elif distance >= casting_range_max: # and enemy_manager.player_detected == true:
#		emit_signal("out_of_range")
#		in_casting_range = false
#	if distance <= casting_range_min and !in_casting_range:
#		emit_signal("casting_range")
#		in_casting_range = true
#		velocity = Vector2.ZERO
