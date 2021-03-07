extends Area2D

onready var inventory = get_node("/root/Inventory_UI").get_child(0)

var attributes = {}

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body.name == "Player":
		if inventory.get_free_slot():
			inventory.add_item(attributes)
			get_tree().queue_delete(self)

func set_attributes(new_attributes):
	self.attributes = new_attributes
