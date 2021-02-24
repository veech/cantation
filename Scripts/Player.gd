extends KinematicBody2D

const SPEED = 300

var motion: Vector2 = Vector2(0, 0)

func _physics_process(delta):
	var x_direction: int = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_direction: int = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	motion.x = x_direction * SPEED
	motion.y = y_direction * SPEED
	
	move_and_slide(motion)
