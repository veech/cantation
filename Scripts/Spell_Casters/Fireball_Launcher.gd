extends "res://Scripts/Base_Classes/Base_Spell_Launcher.gd"


const Fireball = preload("res://Scenes/Projectiles/Fire_Ball.tscn")

func _init():
	print("setting some parameters")
	pool_name = "fireball"
	projectile = Fireball

func cast(caster, mouse_position):
	.cast(caster, mouse_position)

