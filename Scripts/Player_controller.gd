extends "res://Scripts/Base_Classes/Base_Character.gd"


onready var inventory = get_node("/root/Inventory_UI").get_child(0)
onready var spell_set = get_node("/root/Inventory_UI/Inventory/Spells_Set")

var input: Vector2
var facing_direction = Vector2(0,1)

#this gets resized in the func ""update_number_of_spell_slots()"" called in _ready()
#var equipped_spells = []
var current_spell_slot = 0


func _ready():
	set_collision_layer_bit(1, true)
	update_number_of_spell_slots()
	
	#this function is found in Base_Character. Adds node containers to GameManager and populates
	#the array of references to those nodes where we will place the pools.
	set_up_pool_containers()
	for i in range(len(spell_set.slots)):
		var spell_slot = spell_set.slots[i]
		if spell_slot:
			spell_slot.connect("set_spell", self, "set_equipped_spell")
	print(self.get_path())


func _physics_process(delta):
	get_input_axis()
	_animate()

func get_input_axis():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = input.normalized()
	
	_set_facing_direction(input)

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


func _set_facing_direction(input):
	if input.x != 0 && input.y == 0: 
		facing_direction.x = input.x
		facing_direction.y = 0
		
	if input.x == 0 && input.y != 0:
		facing_direction.x = 0
		facing_direction.y = input.y
	
func _animate():
	var in_motion: bool = velocity.x != 0 || velocity.y != 0
	
	if in_motion: _play_motion_animation()
	else: _play_idle_animation()
	
func _play_motion_animation():
	if facing_direction.y < 0:
		$AnimatedSprite.play("up_walk")
	elif facing_direction.y > 0:
		$AnimatedSprite.play("down_walk")
	elif facing_direction.x < 0:
		$AnimatedSprite.play("left_walk")
	elif facing_direction.x > 0:
		$AnimatedSprite.play("right_walk")
	
func _play_idle_animation():
	if facing_direction.y < 0:
		$AnimatedSprite.play("up_idle")
	elif facing_direction.y > 0:
		$AnimatedSprite.play("down_idle")
	elif facing_direction.x < 0:
		$AnimatedSprite.play("left_idle")
	elif facing_direction.x > 0:
		$AnimatedSprite.play("right_idle")

func set_equipped_spell(spell, slot):
	if equipped_spells[slot] != null:
		unequip_spell(slot)
	equipped_spells[slot] = instantiate_spell_caster(spell, slot)

func unequip_spell(slot):
	clear_container_node(slot)
	equipped_spells[slot].unequip(slot)

func set_current_spell(spell_slot):
	current_spell_slot = spell_slot % 4

func get_current_spell():
	return equipped_spells[current_spell_slot]

func update_number_of_spell_slots():
	equipped_spells.resize(len(spell_set.slots))
