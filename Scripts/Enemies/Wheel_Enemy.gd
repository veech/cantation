extends "res://Scripts/Base_Classes/Base_Enemy.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	casting_range_min = 40
	casting_range_max = 70
	equip_spell(Sword_Summoner, Sword_Spellbook)
