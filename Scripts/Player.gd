extends KinematicBody2D

const SPEED = 200

var motion: Vector2 = Vector2(0, 0)

func _physics_process(delta):
	_move()
	_animate()
	
	move_and_slide(motion)
	
func _move():
	var x_direction: int = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_direction: int = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	motion.x = x_direction * SPEED
	motion.y = y_direction * SPEED
	
func _animate():
	if motion.y < 0:
		$AnimatedSprite.play("up_walk")
	elif motion.y > 0:
		$AnimatedSprite.play("down_walk")
	elif motion.x < 0:
		$AnimatedSprite.play("left_walk")
	elif motion.x > 0:
		$AnimatedSprite.play("right_walk")
	else:
		$AnimatedSprite.play("down_idle")
