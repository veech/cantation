extends "res://Scripts/Base_Classes/Base_Projectile.gd"

#this script will need to have a set_attributes function and variables that give
# fireball specific funcitonality. i.e. burn power, burn duration, fireball size, etc

var burn_power = 0
var burn_duration = 0

#var active = false

#gets called when projectile enters body. called from parent class on_body_entered function
func impact_enemy(body, attributes):
	.impact_enemy(body, attributes)
	body.take_damage(attributes['power'])
	body.burn(attributes['burn_power'], attributes['burn_duration'])
	push_body(body, movement_direction, attributes)
	stop_projectile()

