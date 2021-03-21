extends KinematicBody2D

export var max_speed = 150
var speed
var push = Vector2.ZERO

export var max_health: int = 100
export var armor_rating: int = 0
export var fire_resistance: int = 0
export var freeze_resistance: int = 0
export var push_resistance: int = 0
export var push_recovery: float = .1
export var push_sensitivity: int = 100

var current_health = max_health
var frozen = false
var burned = false

var frozen_time_remaining = 0
var burn_time_remaining = 0
var burn_damage = 0
var timer = 0

var velocity: Vector2 = Vector2.ZERO

func _ready():
	speed = max_speed
	
func _physics_process(delta):
	move_character(delta)
	if frozen:
		frozen_time_remaining -= delta
		if frozen_time_remaining <= 0:
			frozen = false
			speed = max_speed
			print("No longer frozen")
	if burned:
		burn_time_remaining -= delta
		timer += delta
		if timer >= 1:
			current_health -= burn_damage
			timer = 0
			print("Burn damage!: current health: ", current_health)
		if burn_time_remaining <= 0:
			burned = false
	
func move_character(delta):
	move_and_slide((velocity * speed) + push)
	push = lerp(push, Vector2.ZERO, push_recovery)
	
func start_push(push_direction, push_power):
	push = push_direction * push_power * push_sensitivity
	
func burn(burn_power, burn_duration):
	self.burn_damage = burn_power
	burn_time_remaining = burn_duration
	burned = true	
	
func freeze(freeze_power, freeze_duration):
	print("frozen")
	speed = max_speed - (max_speed * 1/freeze_power)
	frozen_time_remaining = freeze_duration
	frozen = true
	
func take_damage(damage):
	var health_loss = damage - armor_rating
	current_health -= health_loss
	print("Damage taken!\n\nCurrent Health: ", current_health)
	if current_health <= 0:
		death()

func death():
	print("Im ded")
	self.queue_free()
