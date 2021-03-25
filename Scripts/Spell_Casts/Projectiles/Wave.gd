extends "res://Scripts/Base_Classes/Base_Projectile.gd"


#gets called when projectile enters body. called from parent class on_body_entered function
func impact_body(body):
	knock_back(body, movement_direction)

func on_body_entered(body):
	.on_body_entered(body)

func on_body_exited(body):
	pass

	
