extends Area2D

var movement_direction = Vector2.ZERO

var base_speed = 240
var velocity = Vector2.ZERO
var active = false

var attributes = {"power": 0, "projectile_speed": 0}

signal killed
onready var collision_shape = $CollisionShape2D


func impact_enemy(body, attributes):
	emit_signal("killed", self)
	print("NI: Base_Projectile impact_enemy")

func impact_wall():
	stop_projectile()
	emit_signal("killed", self)
	
func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	collision_shape.disabled = true
	set_collision_layer_bit(4, true)
	
func _physics_process(delta):
	
	velocity = movement_direction * base_speed * attributes['projectile_speed'] * delta
	global_position += velocity

func on_body_entered(body):
	#this is to make sure the caster isnt damaged by his/her own spell
	if body.get_name() == self.attributes["caster"]:
		return
	
	#these might be redundant. the wall one might be necessary since the wall wont have a "damage" function
	if body.is_in_group("Enemies"):
		impact_enemy(body, attributes)
	if body.is_in_group("Player"):
		impact_enemy(body, attributes)
	if body.is_in_group("Wall"):
		impact_wall()
	

func on_body_exited(body):
	pass

func knockback(body, push_strength):
	print("NI")

func push_body(body, push_direction, attributes):
	body.start_push(velocity, attributes['push_power'])

#result must be a DIRECTION i.e. must be normalized before being entered into this function
func set_movement_direction(direction):
	self.movement_direction = direction

func set_attributes(new_attributes):
	self.attributes = new_attributes

func stop_projectile():
	self.movement_direction = Vector2.ZERO
