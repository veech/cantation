extends "res://Scripts/Base_Classes/Base_Spellbook.gd"


const MIN_POWER = 5
const MAX_POWER = 15
const MIN_RADIUS = 1
const MAX_RADIUS = 15
const MIN_RANGE = 15
const MAX_RANGE = 175
const MIN_SHOCK_TIME = 1
const MAX_SHOCK_TIME = 3

func _ready():
	attributes["spell_type"] = Global.SPELLS.LIGHTNING
	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["radius"] = rng.randf_range(MIN_RADIUS, MAX_RADIUS)
	attributes["range"] = rng.randi_range(MIN_RANGE, MAX_RANGE)
	attributes["shock_time"] = rng.randi_range(MIN_SHOCK_TIME, MAX_SHOCK_TIME)
