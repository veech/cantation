extends "res://Scripts/Base_Classes/Base_Spell_Caster.gd"

const Wind_Box = preload("res://Scenes/Non-Projectile_Spells/Wind_Collision_Box.tscn")
const Wind_Draw = preload("res://Scenes/Non-Projectile_Spells/Wind_Draw.tscn")
onready var level = get_node('/root/level')

func set_spell(parent_node, caster):
	casted_spell = Wind_Box.instance()
	casted_spell.position = Vector2(0,0)
	casted_spell.set_attributes(attributes)
	casted_spell.attributes['caster'] = caster.get_name()
	caster.add_child(casted_spell)
	casted_spell.turn_off()

#func cast(caster, mouse_position):
#	if casted_spell != null:
#		casted_spell.queue_free()
#	casted_spell = Wind_Box.instance()
#	casted_spell.position = Vector2(0,0)
#	casted_spell.set_attributes(attributes)
#	casted_spell.attributes['caster'] = caster.get_name()
#	caster.add_child(casted_spell)
#	casted_spell.activate_wind(mouse_position)

func cast(caster, mouse_position):
	if casted_spell != null:
		casted_spell.queue_free()
	casted_spell = Wind_Draw.instance()
	casted_spell.position = Vector2(0,0)
	casted_spell.set_attributes(attributes)
	casted_spell.attributes['caster'] = caster.get_name()
	Game_Manager.add_child(casted_spell)
	casted_spell.cast(mouse_position)

func unequip(slot):
	print("unequipping")
	
func _ready():
	print(level)
