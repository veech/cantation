extends "res://Scripts/Base_Classes/Base_Spellbook.gd"

const MIN_POWER = 5
const MAX_POWER = 15
const MIN_BURN_POWER = 1
const MAX_BURN_POWER = 3
const MIN_PUSH_POWER = .25
const MAX_PUSH_POWER = .75
const MIN_BURN_DURATION = 2
const MAX_BURN_DURATION = 6

func _ready():
	randomize_values()

func randomize_values():
	attributes["spell_type"] = Global.SPELLS.FIRE
	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["push_power"] = rng.randf_range(MIN_PUSH_POWER, MAX_PUSH_POWER)
	attributes["burn_power"] = rng.randi_range(MIN_BURN_POWER, MAX_BURN_POWER)
	attributes["burn_duration"] = rng.randi_range(MIN_BURN_DURATION, MAX_BURN_DURATION)
	attributes["projectile_speed"] = rng.randf_range(.5, 1)
