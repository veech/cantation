extends "res://Scripts/Base_Classes/Base_Spell.gd"

onready var collision_shape = $CollisionShape2D
#var timer: Timer 

#this should def be set by the attributes
var spell_time = 2

func _ready():
	pass

func activate_wind(mouse_position):
	look_at(mouse_position)
	var push_angle = rotation
	push_direction = Vector2(cos(push_angle), sin(push_angle))
	turn_on()
	yield(get_tree().create_timer(spell_time), "timeout")
	print("Spell activated")
	deactivate_spell()

func deactivate_spell():
	turn_off()
	print("Spell deactivated")

func impact_body(body):
	body.nullify_push_recovery()
	knock_back(body, push_direction)
	
func exit_body(body):
	body.reset_push_recovery()
