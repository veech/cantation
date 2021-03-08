extends "res://Scripts/Base_Classes/Base_Projectile.gd"


func impact_enemy(body, attributes):
	.impact_enemy(body, attributes)
	body.take_damage(attributes['power'])
