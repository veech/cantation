extends "res://Scripts/Base_Classes/Base_Spell.gd"

onready var collision_shape = $CollisionShape2D

signal killed

var affected_body

func _ready():
	$Timer.connect("timeout", self, "shock_end")
	
func impact_body(body):
#	affected_body = body
	$Timer.start(attributes["shock_time"])
	body.shock()
	
func shock_end():
	emit_signal("killed", self)
	

func exit_body(body):
	body.end_shock()
