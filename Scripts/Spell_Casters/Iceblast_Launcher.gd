extends "res://Scripts/Base_Classes/Base_Spell_Launcher.gd"

const Iceblast = preload("res://Scenes/Projectiles/Iceblast.tscn")
func _init():
	pool_name = "iceblast"
	spell = Iceblast

func cast(caster, mouse_position):
	.cast(caster, mouse_position)
