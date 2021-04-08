extends "res://Scripts/Base_Classes/Base_Spell_Launcher.gd"


const Fireball = preload("res://Scenes/Projectiles/Fire_Ball.tscn")

const MIN_POWER = 5
const MAX_POWER = 15
const MIN_BURN_POWER = 1
const MAX_BURN_POWER = 3
const MIN_PUSH_POWER = .25
const MAX_PUSH_POWER = .75
const MIN_BURN_DURATION = 2
const MAX_BURN_DURATION = 6
var rng = RandomNumberGenerator.new() 

func _init():
	this_spell = Fireball
	rng.randomize()

func cast(caster, mouse_position):
	.cast(caster, mouse_position)
	

func randomize_attributes():
	attributes["spell_type"] = Global.SPELLS.FIRE
	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["push_power"] = rng.randf_range(MIN_PUSH_POWER, MAX_PUSH_POWER)
	attributes["burn_power"] = rng.randi_range(MIN_BURN_POWER, MAX_BURN_POWER)
	attributes["burn_duration"] = rng.randi_range(MIN_BURN_DURATION, MAX_BURN_DURATION)
	attributes["projectile_speed"] = rng.randf_range(.5, 1)
