extends "res://Scripts/Base_Classes/Base_Character.gd"


onready var inventory = get_node("/root/Inventory_UI").get_child(0)


var input: Vector2
var facing_direction = Vector2(0,1)

func _ready():
	set_collision_layer_bit(1, true)

func _physics_process(delta):
	get_input_axis()
	_animate()

func get_input_axis():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = input.normalized()
	
	_set_facing_direction(input)

func _input(event):
	if event.is_action_pressed("Cast"):
		if inventory.get_current_spell() != null:
			inventory.get_current_spell().cast(self.global_position, get_global_mouse_position(), self.get_name())
		else:
			print("No active spell to cast")
	

func _set_facing_direction(input):
	if input.x != 0 && input.y == 0: 
		facing_direction.x = input.x
		facing_direction.y = 0
		
	if input.x == 0 && input.y != 0:
		facing_direction.x = 0
		facing_direction.y = input.y
	
func _animate():
	var in_motion: bool = velocity.x != 0 || velocity.y != 0
	
	if in_motion: _play_motion_animation()
	else: _play_idle_animation()
	
func _play_motion_animation():
	if facing_direction.y < 0:
		$AnimatedSprite.play("up_walk")
	elif facing_direction.y > 0:
		$AnimatedSprite.play("down_walk")
	elif facing_direction.x < 0:
		$AnimatedSprite.play("left_walk")
	elif facing_direction.x > 0:
		$AnimatedSprite.play("right_walk")
	
func _play_idle_animation():
	if facing_direction.y < 0:
		$AnimatedSprite.play("up_idle")
	elif facing_direction.y > 0:
		$AnimatedSprite.play("down_idle")
	elif facing_direction.x < 0:
		$AnimatedSprite.play("left_idle")
	elif facing_direction.x > 0:
		$AnimatedSprite.play("right_idle")
