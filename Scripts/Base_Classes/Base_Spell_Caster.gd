extends Area2D

var attributes = {}
var casted_spell

var spell_pool
#const POOL_SIZE = 40
#const Pool = preload("res://Scripts/Pool.gd")

var pool_name
var spell

func set_spell_pool(pool):
	self.spell_pool = pool
	
func unset_spell_pool():
	pass
	#spell_pool.queue_free()

func set_spell(parent_node, caster):
	print("Set spell not implemented")

func set_attributes(attributes):
	self.attributes = attributes
	
func get_attributes():
	return attributes

func unequip(slot):
	print("unequip not implemented")
	
func cast(caster, mouse_position):
	print("Cast not implemented")
