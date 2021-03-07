extends KinematicBody2D

const SPEED = 150

var motion: Vector2 = Vector2(0, 0)
var facing_direction: Vector2 = Vector2(0, 1)


#pool variables
const SPELL_POOL_SIZE = 50
const SPELL_POOL_NAME = "Spell"

# Getting the Spell Pool Ready
const Pool = preload("res://Scripts/Pool.gd")
const Spell = preload("res://Scenes/Spell.tscn")

onready var inventory = get_node("/root/Inventory_UI").get_child(0)
onready var pool_location = get_node("../Spell_Pool_Location")
onready var spell_pool = Pool.new(SPELL_POOL_SIZE, SPELL_POOL_NAME, Spell)

func _ready():
	#Pool code
	spell_pool.attach_to_node(pool_location)


func _physics_process(delta):
	_move()
	_animate()
	
	move_and_slide(motion)

func _move():
	var x_direction: int = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_direction: int = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	_set_facing_direction(x_direction, y_direction)
	
	#motion.x = x_direction * SPEED
	#motion.y = y_direction * SPEED
	
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
	if event.is_action_pressed("Attack_A"):
		pass
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if inventory.get_current_spell() != null:
				var direction = (get_global_mouse_position() - global_position).normalized()
				cast_spell(direction)
			else:
				print("No active spell to cast")
	
	#The spell attributes should probably be passed into this function
func cast_spell(direction):
	var spawned_spell = spell_pool.get_inactive_object()
	spawned_spell.set_attributes(inventory.get_current_spell().attributes)
	spawned_spell.global_position = global_position
	spawned_spell.set_movement_direction(direction)
	
	







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
