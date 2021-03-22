extends "res://Scripts/Base_Classes/Base_Spell.gd"


const Sword = preload("res://Scenes/Non-Projectile_Spells/Sword.tscn")
var sword

func cast(caster, mouse_position):
	sword = Sword.instance()
	sword.position = Vector2(0,0)
	print("Sword summoned")
	caster.add_child(sword)
#	sword.position = Vector2(0,0)
	sword.look_at(mouse_position)
#	sword.set_start_direction(mouse_position)
