extends "res://Scripts/Base_Classes/Base_Character.gd"


onready var inventory = get_node("/root/Inventory_UI").get_child(0)
onready var spell_set = get_node("/root/Inventory_UI/Inventory/Spells_Set")

var input: Vector2

var current_spell_slot = 0
var secondary_spell_slot = 1


func _ready():
	layer = 1
	set_collision_layer_bit(layer, true)
	update_number_of_spell_slots()
	print(len(spell_set.slots))
			#this function is found in Base_Character. Adds node containers to GameManager and populates
	#the array of references to those nodes where we will place the pools.
	#sddup_pool_containers()
	for i in range(len(spell_set.slots)):
		var spell_slot = spell_set.slots[i]
		if spell_slot:
			spell_slot.connect("set_spell", self, "set_equipped_spell")
	set_current_spell(current_spell_slot)
	set_secondary_spell(secondary_spell_slot)


func _physics_process(delta):
	get_input_axis()

func get_input_axis():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = input.normalized()

func _unhandled_input(event):
	if event.is_action_pressed("Cast"):
		cast_primary_spell()
	elif event.is_action_pressed("Secondary_Cast"):
		cast_secondary_spell()
	elif event is InputEventKey and event.pressed:
		if event.is_action_pressed("Select_Spell"):
			if event.shift:
				print("select secondary")
				set_secondary_spell(int(event.scancode) - 49) #Translates scancode into integer 1-9
			else:
				print("select")
				set_current_spell(int(event.scancode) - 49)
	elif in_wind_cast or starting_wind_cast:
		if event.is_action_released("Cast") or event.is_action_released("Secondary_Cast"):
			starting_wind_cast = false
			in_wind_cast = false
			ending_wind_cast = true


func cast_primary_spell():
	if get_current_spell() != null:
		get_current_spell().cast(self, get_global_mouse_position())
		facing_direction = global_position.direction_to(get_global_mouse_position())
		cast_animation(get_current_spell())
	else:
		print("No active spell to cast")

func cast_secondary_spell():
	if get_secondary_spell() != null:
		get_secondary_spell().cast(self, get_global_mouse_position())
		cast_animation(get_secondary_spell())
	else:
		print("No active spell to cast")

func cast_animation(spell):
	if spell.attributes['spell_type'] != Global.SPELLS.WIND:
		in_cast = true
		cast_anim_timer.start(2)
	else:
		starting_wind_cast = true

func set_equipped_spell(spell, slot):
	equipped_spells[slot] = instantiate_spell_caster(spell, slot)

func unequip_spell(slot):
	clear_container_node(slot)

func set_current_spell(spell_slot):
	if spell_slot == secondary_spell_slot:
		active_spell_swap()
	current_spell_slot = spell_slot % 9
	set_slot_colors()

func set_secondary_spell(spell_slot):
	if spell_slot == current_spell_slot:
		active_spell_swap()
	secondary_spell_slot = spell_slot % 9
	set_slot_colors()

func active_spell_swap():
	var temp = secondary_spell_slot
	secondary_spell_slot = current_spell_slot
	current_spell_slot = temp

func set_slot_colors():
	for slot in spell_set.slots:
		slot.refresh_colors()
	spell_set.slots[current_spell_slot].set_active_spell_color()
	spell_set.slots[secondary_spell_slot].set_secondary_spell_color()	

func get_current_spell():
	return equipped_spells[current_spell_slot]

func get_secondary_spell():
	return equipped_spells[secondary_spell_slot]
	
func update_number_of_spell_slots():
	equipped_spells.resize(len(spell_set.slots))
