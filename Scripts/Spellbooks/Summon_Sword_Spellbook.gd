extends "res://Scripts/Base_Classes/Base_Spellbook.gd"


const MIN_POWER = 5
const MAX_POWER = 15
const MIN_RANGE = 1
const MAX_RANGE = 3
const MIN_PUSH_POWER = 1
const MAX_PUSH_POWER = 2
const MIN_SPEED = .5
const MAX_SPEED = 1.5

func _ready():
	attributes["spell_type"] = Global.SPELLS.SUMMONSWORD
	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["push_power"] = rng.randf_range(MIN_PUSH_POWER, MAX_PUSH_POWER)
	attributes["range"] = rng.randf_range(MIN_RANGE, MAX_RANGE)
	attributes["speed"] = rng.randf_range(MIN_SPEED, MAX_SPEED)

#maybe we'll also have an attribute for swing speed and swing arc
