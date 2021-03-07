extends "res://Scripts/Base_Spell.gd"

#This pool variable will likely be within the attributes dictionary
var projectile_pool

func cast(cast_position, mouse_position):
	var spawned_spell = projectile_pool.get_inactive_object()
	spawned_spell.set_attributes(self.attributes)
	spawned_spell.set_movement_direction(direction_from_to(cast_position, mouse_position))

func direction_from_to(position_a, position_b):
	var direction = position_b - position_a
	return direction.normalized()
