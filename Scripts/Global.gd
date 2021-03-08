extends Node
class_name Global

enum SlotType {
	SLOT_DEFAULT = 0,
	SLOT_POTION,
	SLOT_SPELL
}

enum SPELLS {
	FIRE = 0,
	ICE,
	WATER,
	SUMMONSWORD
}

const item_images = [
		preload("res://Assets/Icon_Images/fire.png"),
		preload("res://Assets/Icon_Images/wind.png"),
		preload("res://Assets/Icon_Images/water.png"),
		preload("res://Assets/Icon_Images/non_elemental.png"),
		preload("res://Assets/Icon_Images/earth.png"),
]

const overworld_images = [
	preload("res://Assets/Overworld_Sprites/fire_overworld.png"),
	preload("res://Assets/Overworld_Sprites/air_overworld.png"),
	preload("res://Assets/Overworld_Sprites/water_overworld.png"),
	preload("res://Assets/Overworld_Sprites/non_elemental_overworld.png"),
	preload("res://Assets/Overworld_Sprites/earth_overworld.png"),
]
