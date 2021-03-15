extends KinematicBody2D

export var speed = 150
var push = Vector2.ZERO

export var max_health: int = 100
export var armor_rating: int = 0
export var fire_resistance: int = 0
export var freeze_resistance: int = 0
export var push_resistance: int = 0
export var push_recovery: float = .1
export var push_sensitivity: int = 100

var current_health = max_health

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	move_character(delta)
	pass
	
func move_character(delta):
	move_and_slide((velocity * speed) + push)
	push = lerp(push, Vector2.ZERO, push_recovery)
	
func start_push(push_direction, push_power):
	push = push_direction * push_power * push_sensitivity
	
func burn(burn_power, burn_duration):
	pass
	
func freeze(freeze_power, freeze_duration):
	pass
	
func take_damage(damage):
	var health_loss = damage - armor_rating
	current_health -= health_loss
	print("Damage taken!\n\nCurrent Health: ", current_health)
	if current_health <= 0:
		death()

func death():
	print("Im ded")
	self.queue_free()
