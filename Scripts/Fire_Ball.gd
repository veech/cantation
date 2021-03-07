extends "res://Scripts/Base_Projectile.gd"

#this script will need to have a set attributes function and variables that give
# fireball specific funcitonality. i.e. burn power, burn duration, fireball size, etc

var attributes = {}
var burn_power = 0
var burn_duration = 0

func _ready():
	print("Fireball instantiated")

func impact_enemy(body, power):
	.impact_enemy(body, power)
	body.burn(burn_power, burn_duration)

func set_attributes(new_attributes):
	.set_attributes(new_attributes)
	self.burn_power = new_attributes['burn_power']
	self.burn_duration = new_attributes['burn_duration']

