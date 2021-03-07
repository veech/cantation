extends Area2D

onready var inventory = get_node("/root/Inventory_UI").get_child(0)

var attributes = {}
var rng = RandomNumberGenerator.new() 

func _ready():
	connect("body_entered", self, "on_body_entered")
	attributes["slot_type"] = Global.SlotType.SLOT_SPELL
	rng.randomize()

func on_body_entered(body):
	if body.name == "Player":
		if inventory.get_free_slot():
			inventory.add_item(attributes)
			get_tree().queue_delete(self)

func set_attributes(new_attributes):
	self.attributes = new_attributes
