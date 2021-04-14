extends "res://Scripts/Base_Classes/Base_Projectile.gd"

onready var evaporate_particle = $Evaporate

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
	set_scale(get_scale() * .7)
	evaporate_particle.emitting = true
	attributes["push_power"] *= .7
	#queue_free()
