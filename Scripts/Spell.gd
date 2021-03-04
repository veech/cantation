### this is not how this should be done
###	we should instead just have an object pool off screen
### and when a spell is called, the object is moved to the player transform
### the attributes will be used to select the correct spell color and then it will be passed to the spell
### remember to use the facing direction


extends Area2D
class_name Spell

var attributes
var movement_direction = Vector2(0,0)
var spawn_location = Vector2(0,0)
export var base_speed = 250
var speed = 0

signal killed

var active = false

func _init():
	pass
	
func _ready():
	connect("body_entered", self, "on_body_entered")

func _physics_process(delta):
	global_position += movement_direction * speed * delta

func on_body_entered(body):
	if body.get_name() != "Player":
		movement_direction = Vector2.ZERO
		emit_signal("killed", self)


func set_attributes(attributes):
	self.attributes = attributes
	if self.attributes.element == Global.ELEMENTS.NONELEMENTAL:
		$Sprite.region_rect.position.x = 0
	elif self.attributes.element == Global.ELEMENTS.EARTH:
		$Sprite.region_rect.position.x = 16
	elif self.attributes.element == Global.ELEMENTS.WIND:
		$Sprite.region_rect.position.x = 32
	elif self.attributes.element == Global.ELEMENTS.WATER:
		$Sprite.region_rect.position.x = 48
	elif self.attributes.element == Global.ELEMENTS.FIRE:
		$Sprite.region_rect.position.x = 64
	
func set_movement_direction(direction):
	self.movement_direction = direction
	self.speed = base_speed * attributes.projectile_speed
