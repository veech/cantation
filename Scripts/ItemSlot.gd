extends Panel


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
	
	

func refreshColors():
	style.bg_color = Color("#9badb7")
	style.border_color = Color("#252222")
	
