extends Panel


var slots = Array()
var counter = 0

export(Global.SlotType) var slot_type = Global.SlotType.SLOT_SPELL

func _ready():
	for i in $Spell_Slots.get_children():
		slots.push_back(i)
		i.slotIndex = counter
		counter += 1
		print(i, "Slot index = ", i.slotIndex)

#	slots.push_front(get_node("Spell_Slots/Spell_D"))
#	slots.push_front(get_node("Spell_Slots/Spell_C"))
#	slots.push_front(get_node("Spell_Slots/Spell_B"))
#	slots.push_front(get_node("Spell_Slots/Spell_A"))
