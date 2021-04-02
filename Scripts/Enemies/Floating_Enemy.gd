extends "res://Scripts/Base_Classes/Base_Enemy.gd"


func _ready():
	print($CollisionShape2D.get_shape().extents.y)


