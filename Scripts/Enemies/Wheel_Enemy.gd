extends "res://Scripts/Base_Classes/Base_Enemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	casting_range_min = 40
	casting_range_max = 70
	equip_spell(Sword_Summoner)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
