extends "res://Scripts/Base_Classes/Base_Spell_Caster.gd"


	
	
	
func cast(caster, mouse_position):
	var spawned_spell = self.spell_pool.get_inactive_object()
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



func unequip(slot):
	print("unequipping spell")
	unset_spell_pool()
	


func set_attributes(attributes):
	self.attributes = attributes

func set_spell(parent_node, caster):
	self.attributes["caster"] = caster.get_name()
	var new_pool = Pool.new(POOL_SIZE, pool_name, spell, self.attributes)
	new_pool.attach_to_node(parent_node)
	self.spell_pool = new_pool
