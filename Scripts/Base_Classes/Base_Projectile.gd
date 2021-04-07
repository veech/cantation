extends "res://Scripts/Base_Classes/Base_Spell.gd"

var movement_direction = Vector2.ZERO

var base_speed = 240
var velocity = Vector2.ZERO

signal killed
onready var collision_shape = $CollisionShape2D

func impact_body(body):
	queue_free()
	print("NI: Base_Projectile impact_body")

func impact_wall():
	queue_free()
	
func _ready():

	collision_shape.disabled = true
	set_collision_layer_bit(4, true)
	
func _physics_process(delta):
	
	velocity = movement_direction * base_speed * attributes['projectile_speed'] * delta
	global_position += velocity

func on_body_exited(body):
	print("NI body exited")

func knock_back(body, push_direction):
	body.knockback(push_direction, attributes['push_power'])

func end_knock_back(body, push_direction):
	body.reset_push()

func start_push(body, push_direction):
	body.start_push(push_direction, attributes['push_power'])
	
func end_push(body, push_direction):
	body.end_push(push_direction, attributes['push_power'])

#result must be a DIRECTION i.e. must be normalized before being entered into this function
func set_movement_direction(direction):
	self.movement_direction = direction

func set_attributes(new_attributes):
	self.attributes = new_attributes

func stop_projectile():
	self.movement_direction = Vector2.ZERO

func turn_on():
	.turn_on()
	self.active = true

func turn_off():
	.turn_off()
	self.active = false
