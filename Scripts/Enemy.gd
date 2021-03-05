extends KinematicBody2D


var health
var max_health = 100

export var armor_rating = 1

func _ready():
	health = 100
	print("Starting health: ", health)
	
func take_damage(damage):
	var health_loss = damage / armor_rating
	health -= health_loss
	print("Damage taken!\n\nCurrent Health: ", health)
	if health <= 0:
		death()
		
func death():
	print("Im ded")
	self.queue_free()
