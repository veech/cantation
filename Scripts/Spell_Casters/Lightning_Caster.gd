extends "res://Scripts/Base_Classes/Base_Spell_Caster.gd"

const Lightning_Radius = preload("res://Scenes/Non-Projectile_Spells/Lightning_Collision_Radius.tscn")

func _init():
	print("setting some parameters")

func set_spell(parent_node, caster):
	casted_spell = Lightning_Radius.instance()
	casted_spell.position = Vector2(0,0)
	casted_spell.set_attributes(attributes)
	casted_spell.attributes['caster'] = caster.get_name()
	caster.add_child(casted_spell)
	casted_spell.turn_off()

func cast(caster, mouse_position):
	casted_spell = Lightning_Radius.instance()
	casted_spell.position = Vector2(0,0)
	casted_spell.set_attributes(attributes)
	casted_spell.attributes['caster'] = caster.get_name()
	caster.add_child(casted_spell)
	casted_spell.check_radius(caster, mouse_position)
	
func unequip(slot):
	print("Unequipping")
