extends Panel


var slots = Array()

export(Global.SlotType) var slot_type = Global.SlotType.SLOT_DAMAGE_SPELL

func _ready():
	slots.resize(6)
	slots.push_front(get_node("Spell_Slots/Spell_D"))
	slots.push_front(get_node("Spell_Slots/Spell_C"))
	slots.push_front(get_node("Spell_Slots/Spell_B"))
	slots.push_front(get_node("Spell_Slots/Spell_A"))