extends "res://Scripts/Base_Classes/Base_Spell.gd"


const Sword = preload("res://Scenes/Non-Projectile_Spells/Sword.tscn")
var sword

func set_spell(parent_node, caster):
	sword = Sword.instance()
	sword.position = Vector2(0,0)
	sword.set_attributes(attributes)
	sword.attributes['caster'] = caster.get_name()
	caster.add_child(sword)
	sword.turn_off()
	return sword

func cast(caster, mouse_position):
	sword.swing(mouse_position)

func unequip(slot):
	sword.queue_free()
