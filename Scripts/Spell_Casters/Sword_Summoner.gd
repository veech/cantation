extends "res://Scripts/Base_Classes/Base_Spell_Caster.gd"


const Sword = preload("res://Scenes/Non-Projectile_Spells/Sword.tscn")
const MIN_POWER = 5
const MAX_POWER = 15
const MIN_RANGE = 1
const MAX_RANGE = 3
const MIN_PUSH_POWER = 1
const MAX_PUSH_POWER = 2
const MIN_SPEED = .5
const MAX_SPEED = 1.5
var rng = RandomNumberGenerator.new() 

func _ready():
	rng.randomize()

func randomize_attributes():
	attributes["spell_type"] = Global.SPELLS.SUMMONSWORD
	attributes["power"] = rng.randi_range(MIN_POWER, MAX_POWER)
	attributes["push_power"] = rng.randf_range(MIN_PUSH_POWER, MAX_PUSH_POWER)
	attributes["range"] = rng.randf_range(MIN_RANGE, MAX_RANGE)
	attributes["speed"] = rng.randf_range(MIN_SPEED, MAX_SPEED)

func set_spell(parent_node, caster):
	casted_spell = Sword.instance()
	casted_spell.position = Vector2(0,0)
	casted_spell.set_attributes(attributes)
	casted_spell.attributes['caster'] = caster.get_name()
	caster.add_child(casted_spell)
	casted_spell.turn_off()

func cast(caster, mouse_position):
	if casted_spell == null:
		casted_spell = Sword.instance()
		casted_spell.position = Vector2(0,0)
		casted_spell.set_attributes(attributes)
		casted_spell.attributes['caster'] = caster.get_name()
		caster.add_child(casted_spell)
		casted_spell.swing(mouse_position)

func unequip(slot):
	print("Unequipping")
