####	I got this
####	Global enum is used to categorize items. healthPotion, magicPotion, fireSpell, earthSpell, etc
####	all other data about the item is stored in the same class/struct. slot_type, world_sprite, icon_sprite, etc	

extends Panel

const ItemSlotClass = preload("res://Scripts/Inventory/ItemSlot.gd")
const ItemClass = preload("res://Scripts/Inventory/Item.gd")
const ToolTipClass = preload("res://Scripts/Inventory/Tool_Tip.gd")

var equipped_spell_1 = null
var equipped_spell_2 = null
var equipped_spell_3 = null
var equipped_spell_4 = null

var equipped_spells = [null, null, null, null, null]

var current_spell_slot = 0

const MAX_SLOTS = 16

var slotList = Array()

var holding_item = null
var item_offset = Vector2(0, 0)

var game_is_paused = false

onready var tooltip = get_node("../Tool_Tip")
onready var spell_set = get_node("../Inventory/Spells_Set")



# Getting the Spell Pool Ready
const POOL_SIZE = 40
const Pool = preload("res://Scripts/Pool.gd")
const FIREBALL_POOL_NAME = "fireball"
const WAVE_POOL_NAME = "wave"
const ICEBLAST_POOL_NAME = "iceblast"

const Fireball = preload("res://Scenes/Projectiles/Fire_Ball.tscn")
const Wave = preload("res://Scenes/Projectiles/Wave.tscn")
const Iceblast = preload("res://Scenes/Projectiles/Iceblast.tscn")

# Projectile Launchers
const Fireball_Launcher = preload("res://Scripts/Spell_Casts/Fireball_Launcher.gd")
var fireball_launcher: Fireball_Launcher 
const Wave_Launcher = preload("res://Scripts/Spell_Casts/Wave_Launcher.gd")
var wave_launcher: Wave_Launcher
const Iceblast_Launcher = preload("res://Scripts/Spell_Casts/Iceblast_Launcher.gd")
var iceblast_launcher: Iceblast_Launcher

func _ready():
	projectile_pool_setup()

	
	set_visible(false)
	var slots = get_node("Pack/Slots")
	for _i in range(MAX_SLOTS):
		var slot = ItemSlotClass.new()
		slot.connect("mouse_entered", self, "mouse_enter_slot", [slot]);
		slot.connect("mouse_exited", self, "mouse_exit_slot", [slot]);
		slot.connect("gui_input", self, "slot_gui_input", [slot]);
		slotList.append(slot)
		slots.add_child(slot)
		
	for i in range(4):
		var spell_slot = spell_set.slots[i]
		if spell_slot:
			spell_slot.slot_type = Global.SlotType.SLOT_SPELL
			spell_slot.connect("mouse_entered", self, "mouse_enter_slot", [spell_slot]);
			spell_slot.connect("mouse_exited", self, "mouse_exit_slot", [spell_slot]);
			spell_slot.connect("gui_input", self, "slot_gui_input", [spell_slot]);
			spell_slot.connect("set_spell", self, "set_equipped_spell" + "_" + str(i+1))


func slot_gui_input(event: InputEvent, slot: ItemSlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if holding_item:
				if slot.slot_type != Global.SlotType.SLOT_DEFAULT:
					if can_equip(holding_item, slot):
						if !slot.item:
							slot.put_item(holding_item)
							holding_item = null
						else:
							var temp_item = slot.item
							slot.pick_item()
							temp_item.rect_global_position = event.global_position - item_offset
							slot.put_item(holding_item)
							holding_item = temp_item
				elif slot.item:
					var temp_item = slot.item
					slot.pick_item()
					temp_item.rect_global_position = event.global_position - item_offset
					slot.put_item(holding_item)
					holding_item = temp_item
				else:
					slot.put_item(holding_item)
					holding_item = null	
				

			elif slot.item:
				holding_item = slot.item
				item_offset = event.global_position - holding_item.rect_global_position
				slot.pick_item()
				holding_item.rect_global_position = event.global_position - item_offset



func mouse_enter_slot(_slot : ItemSlotClass):
	if _slot.item:
		tooltip.display_tip(_slot.item, get_global_mouse_position())

func mouse_exit_slot(_slot : ItemSlotClass):
	if tooltip.visible:
		tooltip.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		toggle_inventory()
		tooltip.hide()
	elif event is InputEventMouseMotion && holding_item && holding_item.picked:
		holding_item.rect_global_position = event.global_position - item_offset
		
	if event.is_action_pressed("advance_current_spell"):
		set_current_spell(current_spell_slot + 1)
		print("Active spell is spell: ", current_spell_slot + 1)

func toggle_inventory():
	set_visible(!is_visible())
	
func get_free_slot():
	for slot in slotList:
		if !slot.item:
			return slot

func add_item(attributes):
	var slot = get_free_slot()
	if slot:
		slot.set_item(ItemClass.new(attributes, null, Global.item_images[attributes['spell_type']]))
		
func can_equip(item, slot):
	return item.attributes["slot_type"] == slot.slot_type
		
func pick_item(slot, event):
	pass
		
func set_equipped_spell_1(spell):
	equipped_spells[0] = instantiate_spell_launcher(spell)

	
func set_equipped_spell_2(spell):
	equipped_spells[1] = instantiate_spell_launcher(spell) 
	
func set_equipped_spell_3(spell):
	equipped_spells[2] = instantiate_spell_launcher(spell)
	
func set_equipped_spell_4(spell):
	equipped_spells[3] = instantiate_spell_launcher(spell)

func set_current_spell(spell_slot):
	current_spell_slot = spell_slot % 4

func get_current_spell():
	return equipped_spells[current_spell_slot]

func instantiate_spell_launcher(item):
	if !item:
		return null
	match item.attributes["spell_type"]:
		Global.SPELLS.FIRE:
			fireball_launcher.set_attributes(item.attributes)
			return fireball_launcher
		Global.SPELLS.WATER:
			wave_launcher.set_attributes(item.attributes)
			return wave_launcher
		Global.SPELLS.ICE:
			iceblast_launcher.set_attributes(item.attributes)
			return iceblast_launcher
		null:
			print("no spell_type assigned")
		_:
			print("This spell type is not in the switch statement")
		
func projectile_pool_setup():
	
	var fireball_pool = Pool.new(POOL_SIZE, FIREBALL_POOL_NAME, Fireball)		
	fireball_pool.attach_to_node(Game_Manager)	
	fireball_launcher = Fireball_Launcher.new()	
	fireball_launcher.set_spell_pool(fireball_pool)

	var wave_pool = Pool.new(POOL_SIZE, WAVE_POOL_NAME, Wave)		
	wave_pool.attach_to_node(Game_Manager)	
	wave_launcher = Wave_Launcher.new()	
	wave_launcher.set_spell_pool(wave_pool)
	
	var iceblast_pool = Pool.new(POOL_SIZE, ICEBLAST_POOL_NAME, Iceblast)		
	iceblast_pool.attach_to_node(Game_Manager)	
	iceblast_launcher = Iceblast_Launcher.new()	
	iceblast_launcher.set_spell_pool(iceblast_pool)
