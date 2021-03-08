extends NinePatchRect

const Item_Class = preload("res://Scripts/Inventory/Item.gd")

onready var element = get_node("Element")
onready var damage = get_node("Damage")
onready var attack_range = get_node("Range")
onready var speed = get_node("Speed")

func display_tip(_item: Item_Class, mouse_pos: Vector2):
	visible = true
	element.set_text(str(_item.attributes["spell_type"]))
#	damage.set_text("Power: %d" % _item.attributes["power"]) #, _item.attributes.elemental_damage)
	attack_range.set_text("Speed: %d/100" % (_item.attributes["projectile_speed"] * 100))
	#speed.set_text("Speed: %d/100" % (_item.attributes.projectile_speed * 100))

	rect_size = Vector2(128, 256)
	rect_global_position = Vector2(mouse_pos.x + 5, mouse_pos.y + 5)
