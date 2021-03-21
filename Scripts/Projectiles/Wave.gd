extends "res://Scripts/Base_Classes/Base_Projectile.gd"


#gets called when projectile enters body. called from parent class on_body_entered function
func impact_enemy(body, attributes):
	push_body(body, movement_direction, attributes)



# This is def not the way to do this. This is a hack to avoid a bug. 
# once we have player and enemy inheriting from the same base class, we'll also have a way for the spell
# to tell this function who cast it. These entered/exited functions will ignore if the body is the caster
func on_body_entered(body):
	.on_body_entered(body)

func on_body_exited(body):
	pass
#	if body.is_in_group("Enemies"):
#		body.end_push()
	
