extends NinePatchRect

const Item_Class = preload("res://Scripts/Inventory/Item.gd")

onready var Tip = preload("res://Scenes/Inventory/Tip.tscn")

var spacing = 15

func display_tip(_item: Item_Class, mouse_pos: Vector2):
	visible = true
	var tips = _item.get_tips()
	var starting_offset = 2
	var tip_slots = $VBoxContainer.get_children()
	for i in len(tip_slots):
		if len(tips) > i + starting_offset:
			tip_slots[i].set_text(tips[i + starting_offset])
		else:
			
			tip_slots[i].set_text('')
		


#	rect_size = Vector2(128, 256)
	rect_global_position = Vector2(mouse_pos.x + 5, mouse_pos.y + 5)
