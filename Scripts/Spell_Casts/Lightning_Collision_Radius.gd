extends "res://Scripts/Base_Classes/Base_Spell.gd"

onready var collision_shape = $CollisionShape2D


func _ready():
	$Timer.connect("timeout", self, "turn_off")

func check_radius(caster, mouse_position):
	turn_on()
	$Timer.start(.25)
	global_position = mouse_position
	
func impact_body(body):
	body.shock(attributes['shock_time'])
	body.take_damage(attributes['power'])

