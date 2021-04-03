extends "res://Scripts/Base_Classes/Base_Spell_Caster.gd"

var this_spell

func cast(caster, mouse_position):
	var spawned_spell = this_spell.instance()
	spawned_spell.set_attributes(self.attributes)
	var cast_position = caster.global_position
	var movement_direction = direction_from_to(cast_position, mouse_position)
	spawned_spell.set_movement_direction(movement_direction)
	spawned_spell.rotation = movement_direction.angle()
	spawned_spell.global_position = cast_position
	Game_Manager.add_child(spawned_spell)
	spawned_spell.turn_on()
		
func direction_from_to(position_a, position_b):
	var direction = position_b - position_a
	return direction.normalized()
	
func set_attributes(attributes):
	self.attributes = attributes
