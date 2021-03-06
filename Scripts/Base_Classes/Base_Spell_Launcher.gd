extends "res://Scripts/Base_Classes/Base_Spell.gd"

var projectile_pool
#var attributes = {}

#func _init(attributes):
#	self.attributes = attributes	

func cast(cast_position, mouse_position):
	var spawned_spell = self.projectile_pool.get_inactive_object()
	spawned_spell.set_attributes(self.attributes)
	var movement_direction = direction_from_to(cast_position, mouse_position)
	spawned_spell.set_movement_direction(movement_direction)
	spawned_spell.rotation = movement_direction.angle()
	spawned_spell.global_position = cast_position

func direction_from_to(position_a, position_b):
	var direction = position_b - position_a
	return direction.normalized()

func set_spell_pool(pool):
	self.projectile_pool = pool
