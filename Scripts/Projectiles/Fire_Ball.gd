extends "res://Scripts/Base_Classes/Base_Projectile.gd"

var burn_power = 0
var burn_duration = 0

#gets called when projectile enters body. called from parent class on_body_entered function
func impact_body(body):
	.impact_body(body)
	body.take_damage(attributes['power'])
	body.burn(attributes['burn_power'], attributes['burn_duration'])
	knock_back(body, movement_direction)
	stop_projectile()

