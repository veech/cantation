extends Area2D

var attributes = {}
#in child classes with projectiles, one of the attributes need to be the pool or maybe it needs to be a 
#variable passed into the _init() function
var push_direction

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

#in some child classes, cast position will be player position, in others it will be an offset at the player's hand  
func cast(caster, mouse_position):
	print("Cast function not implemented in baseclass")

func impact_wall():
	pass

func on_body_entered(body):
	if body.get_name() == self.attributes["caster"]:
		return
	if body.is_in_group("Wall"):
		impact_wall()
	else:
		impact_body(body)
		
		
func on_body_exited(body):
	print("BaseSpell on body exited")

func impact_body(body):
	print("NI")

func knock_back(body, push_direction):
	body.start_push(push_direction, attributes['push_power'])

func set_attributes(new_attributes):
	self.attributes = new_attributes

func get_attributes():
	return self.attributes

func set_spell(parent_node, caster):
	print("NI in Base_Spell.gd")

func turn_on():
	self.collision_shape.set_deferred("disabled", false)
	self.show()
	
func turn_off():
	self.collision_shape.set_deferred("disabled", true)
	self.hide()	
