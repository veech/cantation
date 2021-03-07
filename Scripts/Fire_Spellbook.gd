extends "res://Scripts/Base_Spellbook.gd"

const MAX_POWER = 10
const MAX_BURN_POWER = 3
const MAX_DURATION = 5

func _init():
	attributes["slot_type"] = Global.SlotType.SLOT_SPELL
	attributes["spell_type"] = Global.ELEMENTS.FIRE
	attributes["power"] = randi() % MAX_POWER
	attributes["burn_power"] = randi() % MAX_BURN_POWER
	attributes["burn_duration"] = randi() % MAX_DURATION
	attributes["projectile_speed"] = rand_range(.5, 1)

func _ready():

	print("From Spellbook: ", attributes)
