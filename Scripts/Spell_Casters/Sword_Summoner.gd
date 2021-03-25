extends "res://Scripts/Base_Classes/Base_Spell_Caster.gd"


const Sword = preload("res://Scenes/Non-Projectile_Spells/Sword.tscn")


func set_spell(parent_node, caster):
	casted_spell = Sword.instance()
	casted_spell.position = Vector2(0,0)
	casted_spell.set_attributes(attributes)
	casted_spell.attributes['caster'] = caster.get_name()
	caster.add_child(casted_spell)
	casted_spell.turn_off()

func cast(caster, mouse_position):
	casted_spell.swing(mouse_position)

func unequip(slot):
	casted_spell.queue_free()
	
