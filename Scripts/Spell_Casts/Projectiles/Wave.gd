extends "res://Scripts/Base_Classes/Base_Projectile.gd"

onready var evaporate_particle = $Evaporate

onready var wave_base = $Wave_Base
onready var foam = $Foam

var foam_timer : Timer

func _ready():
	foam_timer = Timer.new()
	add_child(foam_timer)
	foam_timer.one_shot = true
	foam_timer.connect("timeout", self, "start_foam")
	foam_timer.start(.4)
	
func start_foam():
	foam.emitting = true

func impact_body(body):
	knock_back(body, movement_direction)
	body.end_burn()

func on_body_entered(body):
	.on_body_entered(body)

func on_body_exited(body):
	pass

func impact_spell(area):
	if area.is_in_group('Fireballs'):
		print("impacted fireball")
		area.put_out()
		evaporate()
		
func evaporate():
	set_scale(get_scale() * .9)
	evaporate_particle.emitting = true
	attributes["push_power"] *= .9
	#queue_free()
