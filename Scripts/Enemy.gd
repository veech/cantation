# the push should be something that is called once everytime a pushing body
# enters the enemy body. it should ramp up and then fall in strength.
# Maybe lerp to get the curve. I think it should change the var gradually over time.

#enemy base_class should add the body to the Enemies group

extends KinematicBody2D


var health
var max_health = 100

var speed = 1


export var armor_rating = 1

var burned: bool = false
var burn_remaining = 0
var burn_power = 0

var frozen: bool = false
var freeze_remaining = 0
var freeze_power = 0

export var velocity = Vector2(0,-1)
var initial_push = Vector2.ZERO
var push = Vector2.ZERO
var pushed = false

func _ready():
	health = 100
	print("Starting health: ", health)
	
func take_damage(damage):
	var health_loss = damage / armor_rating
	health -= health_loss
	print("Damage taken!\n\nCurrent Health: ", health)
	if health <= 0:
		death()
	
func _physics_process(delta):
	move_and_collide((velocity * speed) + push)		
	push = lerp(push, Vector2.ZERO, .1)



func _process(delta):
	#global_position += velocity * delta + push
	
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
		
func start_push(push_direction, push_power):
	push = push_direction * push_power
	#if pushed == false:
	#	push = push_direction * push_power
	#	pushed = true
	print("pushed")
	
func end_push():
	pass#pushed = false

func death():
	print("Im ded")
	self.queue_free()
