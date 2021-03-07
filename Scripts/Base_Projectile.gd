extends Area2D

var movement_direction = Vector2.ZERO

#These are probably going to be within the attributes dictionary once I sort that out
var power = 0
var speed = 0
var base_speed = 100

var attributes = {}
#this will have to be connected to the pool in the pool code within the inventory class
signal killed

#Prolly not gonna use this but the damage function will be handled in the 
func impact_enemy(body, power):
	body.take_damage(power)
	#override functions can handle freezing, burning, pushing the body.

func _ready():
	connect("body_entered", self, "on_body_entered")

func _physics_process(delta):
	global_position += movement_direction * base_speed * speed * delta

func on_body_entered(body):
	if body.get_name() != "Player":
		if body.is_in_group("Enemies"):
			impact_enemy(body, power)
		movement_direction = Vector2.ZERO
		emit_signal("killed", self)

#func freeze(body, freeze_duration):
#	pass

#func burn(body, burn_power, burn_duration):
#	pass

func knockback(body, push_strength):
	pass

#result must be a DIRECTION i.e. must be normalized before being entered into this function
func set_movement_direction(direction):
	self.movement_direction = direction

func set_attributes(new_attributes):
#	self.attributes['power'] = new_attributes['power']
#	self.attributes['projectile_speed'] = new_attributes['projectile_speed']
	self.power = new_attributes['power']
	self.speed = new_attributes['projectile_speed']

