extends KinematicBody2D


var health
var max_health = 100

export var armor_rating = 1

var burned: bool = false
var burn_remaining = 0
var burn_power = 0

var frozen: bool = false
var freeze_remaining = 0
var freeze_power = 0

func _ready():
	health = 100
	print("Starting health: ", health)
	
func take_damage(damage):
	var health_loss = damage / armor_rating
	health -= health_loss
	print("Damage taken!\n\nCurrent Health: ", health)
	if health <= 0:
		death()
		
		
func _process(delta):
	if burned == true:
		burn_remaining -= delta
		if burn_remaining <= 0:
			burned = false
			print("Enemy no longer burned")
		
	if frozen == true:
		freeze_remaining -= delta
		if freeze_remaining <= 0:
			frozen = false
			print("Enemy no longer frozen")

func burn(burn_power, burn_duration):
	frozen = false
	burned = true
	self.burn_power = burn_power
	self.burn_remaining = burn_duration 
	print("Enemy burned!")
		
func freeze(freeze_power, freeze_duration):
	burned = false
	frozen = true
	self.freeze_power = freeze_power
	self.freeze_remaining = freeze_duration 
	print("Enemy frozen!")
		
func death():
	print("Im ded")
	self.queue_free()
