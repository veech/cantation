extends "res://Scripts/Base_Classes/Base_Spell_Caster.gd"


const Wind_Box = preload("res://Scenes/Non-Projectile_Spells/Wind_Collision_Box.tscn")

#one way this can work....
	#casting makes a raycast that ignores everything except walls.
	#once the nearest wall within x distance is located, a collision box is sized to that length and activated
	#everyone in the collision box is brought closer 

func set_spell(parent_node, caster):
	casted_spell = Wind_Box.instance()
	casted_spell.position = Vector2(0,0)
	casted_spell.set_attributes(attributes)
	casted_spell.attributes['caster'] = caster.get_name()
	caster.add_child(casted_spell)
	casted_spell.turn_off()
	return casted_spell

func cast(caster, mouse_position):
	casted_spell.activate_wind(mouse_position)

func unequip(slot):
	casted_spell.queue_free()

func _ready():
	pass

