extends "res://Scripts/Base_Classes/Base_Spell.gd"

var look_direction: Vector2

func _ready():
	pass # Replace with function body.


func impact_body(body):
	start_push(body, look_direction)

func exit_body(body):
	end_push(body, look_direction)

func on_body_entered(body):
	if body.is_in_group("Wall"):
		impact_wall()
	#Not sure why this isnt working could be a collision layer/mask thing
	elif body.is_in_group("Spells"):
		queue_free()
	else:
		impact_body(body)

func on_body_exited(body):
	if body.is_in_group("Wall"):
		exit_wall()
	else:
		exit_body(body)

func on_area_entered(area):
	if area.is_in_group('Projectiles'):
		area.target_direction = look_direction
		area.attributes['caster'] = 'rogue'
