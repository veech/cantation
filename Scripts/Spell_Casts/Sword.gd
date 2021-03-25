extends "res://Scripts/Base_Classes/Base_Spell.gd"

#this will be an attribute
var degrees_per_second = 180
#this var should be set in the spellbook attributes
var arc = PI*1.25

var speed = 3
var rot_speed = 0
var start_rotation = 0


onready var collision_shape = $CollisionShape2D
	
func _physics_process(delta):
	self.rotate(deg2rad(degrees_per_second) * delta * rot_speed)
	if get_rotation() >= start_rotation + arc:
		turn_off()

func set_attributes(attributes):
	self.attributes = attributes

func swing(mouse_position):
	look_at(mouse_position)
	turn_on()
	start_rotation = get_rotation()
	var push_angle = start_rotation
	push_direction = Vector2(cos(push_angle), sin(push_angle))
	rot_speed = speed

func impact_body(body):
	body.take_damage(attributes['power'])
	knock_back(body, self.push_direction)

func knock_back(body, push_direction):
	body.start_push(push_direction, attributes['push_power'])
