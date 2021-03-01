### this is not how this should be done
###	we should instead just have an object pool off screen
### and when a spell is called, the object is moved to the player transform
### the attributes will be used to select the correct spell color and then it will be passed to the spell
### remember to use the facing direction


extends Area2D
class_name Spell

var attributes
var facing_direction
var spawn_location
#temporary testing vars
var speed = 1
var spell_range

func _init(facing_direction, spawn_location):
	self.facing_direction = facing_direction
	self.spawn_location = spawn_location
	
func _ready():
	transform = self.spawn_location
	print("I was spawned")
	print("Spell Spawned at: ", transform)
#func _physics_process(delta):
#	position += self.facing_direction * speed * delta	 
