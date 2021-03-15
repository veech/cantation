extends KinematicBody2D

const SPEED = 150

var motion: Vector2 = Vector2(0, 0)
var facing_direction: Vector2 = Vector2(0, 1)

onready var inventory = get_node("/root/Inventory_UI").get_child(0)

func _ready():
	pass


func _physics_process(delta):
	_move()
	_animate()
	
	move_and_slide(motion)

func _move():
	var x_direction: int = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_direction: int = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	_set_facing_direction(x_direction, y_direction)
	
	
	motion = Vector2(x_direction, y_direction).normalized() * SPEED

func _set_facing_direction(x, y):
	if x != 0 && y == 0: 
		facing_direction.x = x
		facing_direction.y = 0
		
	if x == 0 && y != 0:
		facing_direction.x = 0
		facing_direction.y = y
	
func _animate():
	var in_motion: bool = motion.x != 0 || motion.y != 0
	
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


#Player attack code
func _input(event):
	if event.is_action_pressed("Cast"):
		if inventory.get_current_spell() != null:
			inventory.get_current_spell().cast(self.global_position, get_global_mouse_position())
		else:
			print("No active spell to cast")
	





#Player Inventory code. We prolly need to move this to its own script/scene in the near future
enum Potion { HEALTH, MAGIC }
var health_potions = 0
var magic_potions = 0

func add_potion(type):
	if type == Potion.HEALTH:
		health_potions += 1
	else:
		magic_potions += 1
	emit_signal("player_state_changed", self)
	print("Player potion count\n", "Health potions: ", health_potions, "\n", 
		"Magic Potions: ", magic_potions, "\n")
