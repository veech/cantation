extends Node
class_name Global

enum SlotType {
	SLOT_DEFAULT = 0,
	SLOT_POTION,
	SLOT_SPELL
}

enum SPELLS {
	FIRE = 0,
	WIND,
	ICE,
	WATER,
	SUMMONSWORD,
	LIGHTNING
}

const spell_strings = ["Fire", "Wind", "Ice", "Water", "Summon Sword", "Lightning"]

const item_images = [
		preload("res://Assets/Spellbooks/Fire.png"),
		preload("res://Assets/Spellbooks/Wind.png"),
		preload("res://Assets/Spellbooks/Ice.png"),
		preload("res://Assets/Spellbooks/Water.png"),
		preload("res://Assets/Spellbooks/Buckle.png"),
		preload("res://Assets/Spellbooks/Lightning.png"),
]

const overworld_images = [
	preload("res://Assets/Overworld_Sprites/fire_overworld.png"),
	preload("res://Assets/Overworld_Sprites/air_overworld.png"),
	preload("res://Assets/Overworld_Sprites/water_overworld.png"),
	preload("res://Assets/Overworld_Sprites/non_elemental_overworld.png"),
	preload("res://Assets/Overworld_Sprites/earth_overworld.png"),
]
