####	I will have a spellbook and a potion class with a struct for their respective attributes
####	This item class will remain pretty item neutral I think.
####	each item will pass its attributes to the inventory_ui and the slot will store these


extends TextureRect

var attributes = {}
var item_slot

var picked = false

func _init(attributes, item_slot, icon_texture):
	self.attributes = attributes
	texture = icon_texture
	self.item_slot = item_slot
	self.expand = true

func pick_item():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true

func put_item():
	rect_position = Vector2(0, 0)
	mouse_filter = Control.MOUSE_FILTER_PASS
	picked = false

func get_tips():
	var tips = []
	var temp_dict = attributes.duplicate()
	for key in temp_dict.keys():
		if typeof(temp_dict[key]) == TYPE_REAL:
			if key == 'radius':
				temp_dict[key] = str(int(temp_dict[key] * 100))
				temp_dict[key] = temp_dict[key].substr(0, 3)
				#print(temp_dict[key])
			else:
				temp_dict[key] = str(int(temp_dict[key] * 100)) + '%'
				#print(temp_dict[key])
		#This was a stupid attempt to replace the key with a diff name
		if key == 'projectile_speed':
			var temp_key = key
			var temp_value = temp_dict[key]
			temp_dict.erase(key)
			temp_dict['speed'] = temp_value
			key = 'speed'
		elif key == 'caster':
			return tips
		elif key == 'spell_type':
			var tip = ' Spell: ' + Global.spell_strings[temp_dict[key]]
			tips.push_back(tip)
			continue
		var tip = ' ' + key + ': '+ str(temp_dict[key])
		tips.push_back(tip)
	return tips
