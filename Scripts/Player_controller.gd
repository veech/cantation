extends "res://Scripts/Base_Classes/Base_Character.gd"


onready var inventory = get_node("/root/Inventory_UI").get_child(0)
onready var spell_set = get_node("/root/Inventory_UI/Inventory/Spells_Set")

var input: Vector2

var current_spell_slot = 0

func _ready():
	layer = 1
	set_collision_layer_bit(layer, true)
	update_number_of_spell_slots()
	
	#this function is found in Base_Character. Adds node containers to GameManager and populates
	#the array of references to those nodes where we will place the pools.
	#sddup_pool_containers()
	for i in range(len(spell_set.slots)):
		var spell_slot = spell_set.slots[i]
		if spell_slot:
			spell_slot.connect("set_spell", self, "set_equipped_spell")


func _physics_process(delta):
	get_input_axis()

func get_input_axis():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = input.normalized()

func _unhandled_input(event):
	if event.is_action_pressed("Cast"):
		if get_current_spell() != null:
			get_current_spell().cast(self, get_global_mouse_position())
		else:
			print("No active spell to cast")

	if event.is_action_pressed("advance_current_spell"):
		set_current_spell(current_spell_slot + 1)
		print("Active spell is spell: ", current_spell_slot + 1)
	if event.is_action_pressed("delete_active_pool"):
		equipped_spells[current_spell_slot].projectile_pool.queue_free()

func set_equipped_spell(spell, slot):
	equipped_spells[slot] = instantiate_spell_caster(spell, slot)

func unequip_spell(slot):
	clear_container_node(slot)

func set_current_spell(spell_slot):
	current_spell_slot = spell_slot % 4

func get_current_spell():
	return equipped_spells[current_spell_slot]

func update_number_of_spell_slots():
	equipped_spells.resize(len(spell_set.slots))
