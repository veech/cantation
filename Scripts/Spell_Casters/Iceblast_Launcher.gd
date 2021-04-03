extends "res://Scripts/Base_Classes/Base_Spell_Launcher.gd"

const Iceblast = preload("res://Scenes/Projectiles/Iceblast.tscn")
func _init():
	this_spell = Iceblast

func cast(caster, mouse_position):
	.cast(caster, mouse_position)
