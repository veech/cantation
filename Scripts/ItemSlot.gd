extends Panel

export(Global.SlotType) var slot_type = Global.SlotType.SLOT_DEFAULT

var slotIndex
var item = null
var style

func _init():
	
	rect_min_size = Vector2(52, 52)
	style = StyleBoxFlat.new()
	refreshColors()
	style.set_border_width_all(3)
	style.set_corner_radius_all(5)
	
	set('custom_styles/panel', style)

func set_item(new_item):
	add_child(new_item)
	item = new_item
	item.item_slot = self
	item.set_size(Vector2(64, 64))
	
func pick_item():
	item.pick_item()
	remove_child(item)
	Inventory_UI.add_child(item)
	item = null
	
func put_item(new_item):
	item = new_item
	item.item_slot = self
	item.put_item()
	Inventory_UI.remove_child(item)
	add_child(item)

func refreshColors():
	style.bg_color = Color("#9badb7")
	style.border_color = Color("#252222")
	
