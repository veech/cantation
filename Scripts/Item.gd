####	I will have a spellbook and a potion class with a struct for their respective attributes
####	This item class will remain pretty item neutral I think.
####	each item will pass its attributes to the inventory_ui and the slot will store these


extends TextureRect

var attributes
var item_slot

func _init(attributes, item_slot, icon_texture):
	self.attributes = attributes
	texture = icon_texture
	self.item_slot = item_slot
