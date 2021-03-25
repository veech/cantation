extends Area2D

#maybe, what I need to do is have the Summon_Sword script be attached to the sword.
#Equipping the sword spell will instance the sword scene. and add it to the player as a child.
#swings will activate the node, swing it, and then deactivate it.

var attributes = {}

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
	rot_speed = speed
	print(start_rotation)

func turn_on():
	self.collision_shape.set_deferred("disabled", false)
	self.show()
	
func turn_off():
	self.collision_shape.set_deferred("disabled", true)
	self.hide()	

var push_direction = start_rotation + PI/2

func impact_body(body, attributes):
	pass

func push_body(body, push_direction, attributes):
	body.start_push(push_direction, attributes['push_power'])
