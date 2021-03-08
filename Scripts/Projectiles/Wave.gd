extends "res://Scripts/Base_Classes/Base_Projectile.gd"


#gets called when projectile enters body. called from parent class on_body_entered function
func impact_enemy(body, attributes):
	.impact_enemy(body, attributes)
	push_body(body, movement_direction, attributes)

func push_body(body, push_direction, attributes):
	body.start_push(push_direction, attributes['push_power'])
	print("NI: push_body")

func on_body_entered(body):
	if body.get_name() != "Player":
		if body.is_in_group("Enemies"):
			impact_enemy(body, attributes)
			return
		movement_direction = Vector2.ZERO
		emit_signal("killed", self)

func on_body_exited(body):
	if body.is_in_group("Enemies"):
		body.end_push()
	
