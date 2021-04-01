extends Panel


var slots = Array()
var counter = 0

export(Global.SlotType) var slot_type = Global.SlotType.SLOT_SPELL

func _ready():
	for i in $Spell_Slots.get_children():
		slots.push_back(i)
		i.slotIndex = counter
		counter += 1
