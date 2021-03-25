extends "res://Scripts/Base_Classes/Base_Spell.gd"

var projectile_pool
const POOL_SIZE = 40
const Pool = preload("res://Scripts/Pool.gd")

func cast(caster, mouse_position):
	var spawned_spell = self.projectile_pool.get_inactive_object()
	if !spawned_spell:
		print("Tried to spawn NIL.")
		return
	var cast_position = caster.global_position
	var movement_direction = direction_from_to(cast_position, mouse_position)
	spawned_spell.set_movement_direction(movement_direction)
	spawned_spell.rotation = movement_direction.angle()
	spawned_spell.global_position = cast_position

func direction_from_to(position_a, position_b):
	var direction = position_b - position_a
	return direction.normalized()

func set_spell_pool(pool):
	self.projectile_pool = pool

func unequip_spell():
	.unequip_spell()
	print("unequipping spell")
	unset_spell_pool()
	
func unset_spell_pool():
	projectile_pool.queue_free()

func set_attributes(attributes):
	self.attributes = attributes

#	This might be the way. move the pool construction into each launcher
#func instantiate_projectile_pool(projectile, pool_name, parent_node, spell_attributes, caster):
#	var new_pool = Pool.new(POOL_SIZE, pool_name, projectile, spell_attributes, caster)
#	new_pool.attach_to_node(parent_node)
#	return new_pool
#
#func set_spell():
#	pass
