#####	I think how I need this to work is that all the data related to each spellbook is contained in one struct
#####	then that struct is passed onto the inventory and that struct is stored in an array.
#####
#####	Also, maybe the individual item does get collision info from the player but then passes its data on to the 
#####	inventory scene which is a child node of the player? That way we can separate out duties between scripts
#####
#####	Getting the overworld sprite is easy, I can leave it as is for the most part
#####	Getting the icon sprite however... Maybe I have some sort of similar setup where I have them all on the same sprite sheet
#####	and I select them based on the item type/element

tool extends Area2D
var attributes
onready var inventory = get_node("/root/Inventory_UI").get_child(0)


class Attributes:
	var slot_type = Global.SlotType.SLOT_DAMAGE_SPELL
	var element
	var damage
	var elemental_damage
	var projectile_range
	var projectile_speed
	var burst_radius

	
	func _init():
		randomize()
		self.element = randi() % len(Global.ELEMENTS)
		self.damage = randi() % 10
		self.elemental_damage = randi() % 5
		self.projectile_range = randi() % 20 + 10
		self.projectile_speed = randi() % 30 + 15
		self.burst_radius = randi() % 5
		
	func print_attributes():
		print("element: ", self.element)
		print("damage: ", self.damage)
		print("elemental_damage: ", self.elemental_damage)
		print("projectile_range: ", self.projectile_range)
		print("projectile_speed: ", self.projectile_speed)
		print("burst_radius: ", self.burst_radius)

func _init(attributes = Attributes.new()):
	self.attributes = attributes

func _ready():
	#Necessary to generate seed for spell randomization
	randomize()
	if attributes.element == Global.ELEMENTS.NONELEMENTAL:
		$Sprite.region_rect.position.x = 0
	elif attributes.element == Global.ELEMENTS.EARTH:
		$Sprite.region_rect.position.x = 16
	elif attributes.element == Global.ELEMENTS.WIND:
		$Sprite.region_rect.position.x = 32
	elif attributes.element == Global.ELEMENTS.WATER:
		$Sprite.region_rect.position.x = 48
	elif attributes.element == Global.ELEMENTS.FIRE:
		$Sprite.region_rect.position.x = 64



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attributes.element == Global.ELEMENTS.NONELEMENTAL:
		$Sprite.region_rect.position.x = 0
	elif attributes.element == Global.ELEMENTS.EARTH:
		$Sprite.region_rect.position.x = 16
	elif attributes.element == Global.ELEMENTS.WIND:
		$Sprite.region_rect.position.x = 32
	elif attributes.element == Global.ELEMENTS.WATER:
		$Sprite.region_rect.position.x = 48
	elif attributes.element == Global.ELEMENTS.FIRE:
		$Sprite.region_rect.position.x = 64


func _on_Spellbook_body_entered(body):
	if body.name == "Player":
		if inventory.get_free_slot():
			body.add_spellbook(attributes)
			inventory.add_item(attributes)
			get_tree().queue_delete(self)
			
			
