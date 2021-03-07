extends "res://Scripts/Base_Classes/Base_Spellbook.gd"

const MIN_POWER = 5
const MAX_POWER = 15
const MIN_BURN_POWER = 1
const MAX_BURN_POWER = 3
const MIN_BURN_DURATION = 2
const MAX_BURN_DURATION = 6

func _ready():
	print("From Spellbook: ", attributes)
	attributes["spell_type"] = Global.ELEMENTS.FIRE
	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["burn_power"] = rng.randi_range(MIN_BURN_POWER, MAX_BURN_POWER)
	attributes["burn_duration"] = rng.randi_range(MIN_BURN_DURATION, MAX_BURN_DURATION)
	attributes["projectile_speed"] = rng.randf_range(.5, 1)
