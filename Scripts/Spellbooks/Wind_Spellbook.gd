extends "res://Scripts/Base_Classes/Base_Spellbook.gd"

const MIN_POWER = 5
const MAX_POWER = 15

const MIN_PUSH_POWER = -.5
const MAX_PUSH_POWER = -1
const MIN_WIDTH = 1
const MAX_WIDTH = 6

func _ready():
	attributes["spell_type"] = Global.SPELLS.WIND
#	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["push_power"] = rng.randf_range(MIN_PUSH_POWER, MAX_PUSH_POWER)
	attributes["width"] = rng.randi_range(MIN_WIDTH, MAX_WIDTH) # maybe this can just scale the box width
	attributes["projectile_speed"] = rng.randf_range(.75, 1) # percentage of max speed
