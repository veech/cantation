extends "res://Scripts/Base_Classes/Base_Spellbook.gd"
#push force should be a percentage of velocity so that the enemy is never pushed back faster than the wave

const MIN_POWER = 5
const MAX_POWER = 15

const MIN_PUSH_POWER = 2
const MAX_PUSH_POWER = 5
const MIN_WIDTH = 1
const MAX_WIDTH = 6

func _ready():
	print("From Spellbook: ", attributes)
	attributes["spell_type"] = Global.SPELLS.WATER
#	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["push_power"] = 1 #rng.randi_range(MIN_PUSH_POWER, MAX_PUSH_POWER)
	attributes["width"] = rng.randi_range(MIN_WIDTH, MAX_WIDTH) # maybe this can just scale the projectile
	attributes["projectile_speed"] = rng.randf_range(.75, 1) # percentage of max speed
