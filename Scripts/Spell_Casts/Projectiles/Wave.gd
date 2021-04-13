extends "res://Scripts/Base_Classes/Base_Projectile.gd"

func impact_body(body):
	knock_back(body, movement_direction)

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
	queue_free()
