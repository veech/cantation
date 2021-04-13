extends Area2D

var attributes = {}
var active = true
var push_direction

func _init():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	connect("area_entered", self, "on_area_entered")
	connect("area_exited", self, "on_area_exited")

func impact_wall():
	pass

func on_body_entered(body):
	if body.get_name() == self.attributes["caster"]:
		return
	elif body.is_in_group("Wall"):
		impact_wall()
	#Not sure why this isnt working could be a collision layer/mask thing
	elif body.is_in_group("Spells"):
		queue_free()
	else:
		impact_body(body)
		
func on_body_exited(body):
	if body.get_name() == self.attributes["caster"]:
		return
	if body.is_in_group("Wall"):
		exit_wall()
	else:
		exit_body(body)

func on_area_entered(area):
	impact_projectile(area)
	
func on_area_exited(area):
	pass

func exit_body(body):
	pass
	
func exit_wall():
	pass

func impact_projectile(area):
	pass

func impact_body(body):
	print("NI")

func knock_back(body, push_direction):
	body.knockback(push_direction, attributes['push_power'])

func end_knock_back(body, push_direction):
	body.reset_push()

func start_push(body, push_direction):
	body.start_push(push_direction, attributes['push_power'])
	
func end_push(body, push_direction):
	body.end_push(push_direction, attributes['push_power'])

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
