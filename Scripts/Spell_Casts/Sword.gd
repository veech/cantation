extends Area2D

#maybe, what I need to do is have the Summon_Sword script be attached to the sword.
#Equipping the sword spell will instance the sword scene. and add it to the player as a child.
#swings will activate the node, swing it, and then deactivate it.

var attributes = {}

#this will be an attribute
var degrees_per_second = 180
var speed = 3
var start_rotation = 0


func _ready():
	print(rotation)
	
func _physics_process(delta):
	self.rotate(deg2rad(degrees_per_second) * delta * speed)
	#print(rotation)
	#if self.rotation >= start_rotation:
	#	self.queue_free()


func set_attributes(attributes):
	self.attributes = attributes

func set_start_direction(look_direction):
	look_at(look_direction)
	start_rotation = self.rotation
	
