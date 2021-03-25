extends "res://Scripts/Base_Classes/Base_Spell_Caster.gd"


const Lightning = preload("res://Scenes/Non-Projectile_Spells/Lightning_Spell.tscn")

func _init():
	print("setting some parameters")
	pool_name = "lightning"
	spell = Lightning

func set_spell(parent_node, caster):
	self.attributes["caster"] = caster.get_name()
	var new_pool = Pool.new(POOL_SIZE, pool_name, spell, self.attributes)
	new_pool.attach_to_node(parent_node)
	self.spell_pool = new_pool


func cast(caster, mouse_position):
	pass
	
func unequip(slot):
	pass
