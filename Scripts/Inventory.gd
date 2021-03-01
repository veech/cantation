####	I got this
####	Global enum is used to categorize items. healthPotion, magicPotion, fireSpell, earthSpell, etc
####	all other data about the item is stored in the same class/struct. slot_type, world_sprite, icon_sprite, etc	

extends Panel

const ItemSlotClass = preload("res://Scripts/ItemSlot.gd")
const ItemClass = preload("res://Scripts/Item.gd")

const MAX_SLOTS = 36

var slotList = Array()

func _ready():
	set_visible(false)
	var slots = get_node("SlotsContainer/Slots")
	for _i in range(MAX_SLOTS):
		var slot = ItemSlotClass.new()
		slotList.append(slot)
		slots.add_child(slot)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		toggle_visibility()

func toggle_visibility():
	if is_visible():
		set_visible(false)
	else:
		set_visible(true)
				

func get_free_slot():
	for slot in slotList:
		if !slot.item:
			return slot

func add_item(attributes):
	var slot = get_free_slot()
	if slot:
		slot.set_item(ItemClass.new(attributes, null, Global.item_images[attributes.element]))
		
		
		
		
		
		
