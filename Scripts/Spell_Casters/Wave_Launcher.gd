extends "res://Scripts/Base_Classes/Base_Spell_Launcher.gd"

const Wave = preload("res://Scenes/Projectiles/Wave.tscn")


# this wave spawner will have to handle how many waves get spawned with a "width" attribute and maybe use a radius to get 
#placement correct
func _init():
	this_spell = Wave
	
func cast(caster, mouse_position):
	.cast(caster, mouse_position)
