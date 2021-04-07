extends "res://Scripts/Base_Classes/Base_Spell.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var look_direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func impact_body(body):
	#body.nullify_push_recovery()
	start_push(body, look_direction)

func exit_body(body):
	print("exit called")
	#body.reset_push_recovery()
	end_push(body, look_direction)

func on_body_entered(body):
#	if body.get_name() == self.attributes["caster"]:
#		print("entered called")
#		impact_body(body)
	if body.is_in_group("Wall"):
		impact_wall()
	#Not sure why this isnt working could be a collision layer/mask thing
	elif body.is_in_group("Spells"):
		queue_free()
	else:
		impact_body(body)

func on_body_exited(body):
#	if body.get_name() == self.attributes["caster"]:
#		exit_body(body)
	if body.is_in_group("Wall"):
		exit_wall()
	else:
		exit_body(body)
