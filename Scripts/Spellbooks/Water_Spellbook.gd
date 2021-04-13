extends "res://Scripts/Base_Classes/Base_Spellbook.gd"
#push force should be a percentage of velocity so that the enemy is never pushed back faster than the wave

const MIN_PUSH_POWER = .5
const MAX_PUSH_POWER = 1
const MIN_WIDTH = 1
const MAX_WIDTH = 6

func _ready():
	randomize_values()

func randomize_values():
	attributes["spell_type"] = Global.SPELLS.WATER
	attributes["push_power"] = rng.randf_range(MIN_PUSH_POWER, MAX_PUSH_POWER)
	attributes["width"] = rng.randi_range(MIN_WIDTH, MAX_WIDTH) 
	attributes["projectile_speed"] = rng.randf_range(.75, 1)
