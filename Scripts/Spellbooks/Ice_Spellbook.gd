extends "res://Scripts/Base_Classes/Base_Spellbook.gd"


const MIN_POWER = 1
const MAX_POWER = 8

const MIN_FREEZE_POWER = 1
const MAX_FREEZE_POWER = 3
const MIN_FREEZE_DURATION = 1
const MAX_FREEZE_DURATION = 4
const MIN_RADIUS = 1
const MAX_RADIUS = 6

func _ready():
	print("From Spellbook: ", attributes)
	attributes["spell_type"] = Global.ELEMENTS.ICE
	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["freeze_power"] = rng.randi_range(MIN_FREEZE_POWER, MAX_FREEZE_POWER)
	attributes["freeze_duration"] = rng.randi_range(MIN_FREEZE_DURATION, MAX_FREEZE_DURATION)
	attributes["radius"] = rng.randi_range(MIN_RADIUS, MAX_RADIUS)
	attributes["projectile_speed"] = rng.randf_range(.5, 1)
