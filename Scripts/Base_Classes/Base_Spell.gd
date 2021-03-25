extends Area2D

var attributes = {}
#in child classes with projectiles, one of the attributes need to be the pool or maybe it needs to be a 
#variable passed into the _init() function

func _ready():
	pass
#in some child classes, cast position will be player position, in others it will be an offset at the player's hand  
func cast(caster, mouse_position):
	print("Cast function not implemented in child class")
	
func impact_enemy(power, body):
	print("NI")
	
func set_attributes(new_attributes):
	self.attributes = new_attributes
	
func get_attributes():
	return self.attributes
	
#I think the spell/spell_launcher is not getting destroyed
func unequip_spell():
	print("Spell_unequipped!")
