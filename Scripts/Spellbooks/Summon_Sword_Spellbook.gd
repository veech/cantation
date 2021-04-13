extends "res://Scripts/Base_Classes/Base_Spellbook.gd"


const MIN_POWER = 5
const MAX_POWER = 15
const MIN_RANGE = 1
const MAX_RANGE = 3
const MIN_PUSH_POWER = 1
const MAX_PUSH_POWER = 2
const MIN_SPEED = 2
const MAX_SPEED = 4

const MIN_ARC = 1
const MAX_ARC = 1.5


func _ready():
	randomize_values()

func randomize_values():
	attributes["spell_type"] = Global.SPELLS.SUMMONSWORD
	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["push_power"] = rng.randf_range(MIN_PUSH_POWER, MAX_PUSH_POWER)
	attributes["range"] = rng.randf_range(MIN_RANGE, MAX_RANGE)
	attributes["speed"] = rng.randf_range(MIN_SPEED, MAX_SPEED)
	attributes["arc"] = rng.randf_range(MIN_ARC, MAX_ARC) * PI
