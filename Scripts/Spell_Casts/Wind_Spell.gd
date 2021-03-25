extends "res://Scripts/Base_Classes/Base_Spell.gd"

onready var collision_shape = $CollisionShape2D
#var timer: Timer 

#this should def be set by the attributes
var spell_time = 2

func _ready():
	$Spell_Timer.connect("timeout", self, "deactivate_spell")

func activate_wind(mouse_position):
	$Spell_Timer.stop()
	look_at(mouse_position)
	var push_angle = rotation
	push_direction = Vector2(cos(push_angle), sin(push_angle))
	turn_on()
	$Spell_Timer.start(spell_time)

func deactivate_spell():
	turn_off()
	print("Spell deactivated")

func impact_body(body):
	body.nullify_push_recovery()
	knock_back(body, push_direction)
	
func exit_body(body):
	body.reset_push_recovery()
