extends RigidBody2D

var push_modifier = 200
var pushed = false

func start_push(push_direction, push_power):
	if !pushed:
		apply_central_impulse(push_direction * push_power * push_modifier)
		pushed = true

func end_push():
	pushed = false
