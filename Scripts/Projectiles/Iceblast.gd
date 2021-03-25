extends "res://Scripts/Base_Classes/Base_Projectile.gd"


func impact_body(body):
	.impact_body(body)
	body.take_damage(attributes['power'])
	body.freeze(attributes['freeze_power'], attributes['freeze_duration'])
	stop_projectile()
