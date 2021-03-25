extends KinematicBody2D

export var max_speed = 150
var speed
var push = Vector2.ZERO

export var max_health: int = 100
export var armor_rating: int = 0
export var fire_resistance: int = 0
export var freeze_resistance: int = 0
export var push_resistance: int = 0
export var push_recovery: float = .1
export var push_sensitivity: int = 100

var current_health = max_health
var frozen = false
var burned = false

var frozen_time_remaining = 0
var burn_time_remaining = 0
var burn_damage = 0
var timer = 0

var velocity: Vector2 = Vector2.ZERO

var pool_node_list = Array()
var Character_Spell_Container_Node = preload("res://Scenes/Utilities/Character_Spell_Container_Node.tscn")
var Pool_Container = preload("res://Scenes/Utilities/Pool_Container.tscn")

var spell_container: Node2D

func _ready():

	speed = max_speed
	
func _physics_process(delta):
	move_character(delta)
	if frozen:
		frozen_time_remaining -= delta
		if frozen_time_remaining <= 0:
			frozen = false
			speed = max_speed
			print("No longer frozen")
	if burned:
		burn_time_remaining -= delta
		timer += delta
		if timer >= 1:
			current_health -= burn_damage
			timer = 0
			print("Burn damage!: current health: ", current_health)
		if burn_time_remaining <= 0:
			burned = false
	
func move_character(delta):
	move_and_slide((velocity * speed) + push)
	push = lerp(push, Vector2.ZERO, push_recovery)
	
func start_push(push_direction, push_power):
	push = push_direction * push_power * push_sensitivity
	
func burn(burn_power, burn_duration):
	self.burn_damage = burn_power
	burn_time_remaining = burn_duration
	burned = true	
	
func freeze(freeze_power, freeze_duration):
	print("frozen")
	speed = max_speed - (max_speed * 1/freeze_power)
	frozen_time_remaining = freeze_duration
	frozen = true
	
func take_damage(damage):
	var health_loss = damage - armor_rating
	current_health -= health_loss
	print("Damage taken!\n\nCurrent Health: ", current_health)
	if current_health <= 0:
		death()

func death():
	print("Im ded")



# pool setup should be a generic function that sets up one pool at a time.
# that way, enemies can have a single spell equipped and have their own pool for that spell.

# Getting the Spell Pool Ready
const POOL_SIZE = 40
const Pool = preload("res://Scripts/Pool.gd")
const FIREBALL_POOL_NAME = "fireball"
const WAVE_POOL_NAME = "wave"
const ICEBLAST_POOL_NAME = "iceblast"

const Fireball = preload("res://Scenes/Projectiles/Fire_Ball.tscn")
const Wave = preload("res://Scenes/Projectiles/Wave.tscn")
const Iceblast = preload("res://Scenes/Projectiles/Iceblast.tscn")

# Projectile Launchers
const Fireball_Launcher = preload("res://Scripts/Spell_Casts/Fireball_Launcher.gd")
#var fireball_pool : Pool
const Wave_Launcher = preload("res://Scripts/Spell_Casts/Wave_Launcher.gd")
#var wave_pool : Pool
const Iceblast_Launcher = preload("res://Scripts/Spell_Casts/Iceblast_Launcher.gd")
#var iceblast_pool: Pool

#Non-projectile Spell Scripts
const Summon_Sword = preload("res://Scripts/Spell_Casts/Summon_Sword.gd")
const Wind_Spell = preload("res://Scripts/Spell_Casts/Wind_Spell.gd")
const Lightning_Spell = preload("res://Scripts/Spell_Casts/Lightning_Spell.gd")
##### up to this point everything should be in base character
	
var equipped_spells = []
#var spell_pool_parent_nodes = []
# the ready function in the player controller will resize this list to the length of the possible equipped spells
# node2d will be added to playercontroller with children being the pool objects. a reference to these node2ds
#will be stored in the container.
# if the objects are children of the player, theyre gonna move with the player. maybe this method can work 
# with them attached to the gamemanager node still
#maybe, I attach a node2d to the gamemanager that is called "self.get_name() + '_spell_pools'"
#and I attach the pool node2Ds to that in the ready function. 


### this should be in the basecharacter class and each branch of the switch statement should 
### also instance the appropriate pool scenes

### this is where the magic happens
### this function needs to.....
###	---	read the slot that called it and the spell added to the slot
###	---	use the spell index to add the pool to the correct 

#func instantiate_spell_caster(item, slot):
#	if !item:
#		return null
#	match item.attributes["spell_type"]:
#		Global.SPELLS.FIRE:
#			var fireball_launcher = Fireball_Launcher.new()
#
#			#Base class has projectile, pool_name, pool_size
#			#and the set_spell_pool function which only takes slot node (parent node) as an arg
#			# 
#
#			fireball_launcher.set_spell_pool(instantiate_projectile_pool(Fireball, FIREBALL_POOL_NAME, slot, item.attributes))
#			return fireball_launcher
#		Global.SPELLS.WATER:
#			var wave_launcher = Wave_Launcher.new()
#			wave_launcher.set_spell_pool(instantiate_projectile_pool(Wave, WAVE_POOL_NAME, slot, item.attributes))
#			return wave_launcher
#		Global.SPELLS.ICE:
#			var iceblast_launcher = Iceblast_Launcher.new()
#			iceblast_launcher.set_spell_pool(instantiate_projectile_pool(Iceblast, ICEBLAST_POOL_NAME, slot, item.attributes))
#			return iceblast_launcher
#
#		#The rest of these should return the correct spell script so the player can call cast.
#		Global.SPELLS.SUMMONSWORD:
#			var summon_sword = Summon_Sword.new()
#			summon_sword.set_attributes(item.attributes)
#			return summon_sword
#		Global.SPELLS.LIGHTNING:
#			var lightning_spell = Lightning_Spell.new()
#			lightning_spell.set_attributes(item.attributes)
#			return lightning_spell
#		Global.SPELLS.WIND:
#			var wind_spell = Wind_Spell.new()
#			wind_spell.set_attributes(item.attributes)
#			return wind_spell
#		null:
#			print("no spell_type assigned")
#		_:
#			print("This spell type is not in the switch statement")
#










func instantiate_spell_caster(item, slot):
	if !item:
		return null
	match item.attributes["spell_type"]:
		Global.SPELLS.FIRE:
			var fireball_launcher = Fireball_Launcher.new()
			
			#Base class has projectile, pool_name, pool_size
			#and the set_spell_pool function which only takes slot node (parent node) as an arg
			# 
			
			fireball_launcher.set_spell_pool(instantiate_projectile_pool(Fireball, FIREBALL_POOL_NAME, slot, item.attributes))
			return fireball_launcher
		Global.SPELLS.WATER:
			var wave_launcher = Wave_Launcher.new()
			wave_launcher.set_spell_pool(instantiate_projectile_pool(Wave, WAVE_POOL_NAME, slot, item.attributes))
			return wave_launcher
		Global.SPELLS.ICE:
			var iceblast_launcher = Iceblast_Launcher.new()
			iceblast_launcher.set_spell_pool(instantiate_projectile_pool(Iceblast, ICEBLAST_POOL_NAME, slot, item.attributes))
			return iceblast_launcher
			
		#The rest of these should return the correct spell script so the player can call cast.
		Global.SPELLS.SUMMONSWORD:
			var summon_sword = Summon_Sword.new()
			summon_sword.set_attributes(item.attributes)
			return summon_sword
		Global.SPELLS.LIGHTNING:
			var lightning_spell = Lightning_Spell.new()
			lightning_spell.set_attributes(item.attributes)
			return lightning_spell
		Global.SPELLS.WIND:
			var wind_spell = Wind_Spell.new()
			wind_spell.set_attributes(item.attributes)
			return wind_spell
		null:
			print("no spell_type assigned")
		_:
			print("This spell type is not in the switch statement")














#####################This is my next step right here
#maybe there will be a new pool for each spell even if 4 of one spell is equipped
# that way, each pool can have the spells attributes assigned to each projectile at THIS point.
# So it won't have to keep reassigning values at every cast. better for cpu usage, slightly harder on ram usage
#I need to find a way to clear the pool once the spell is unequipped..... might be difficult and force more
#restructuring. maybe the gamemanager node isnt the best place to attach the pool. though it is accessible
#from anywhere

#this creates some pool containers on the gamemanager node
		## maybe in the player controller, I can add the specific functionality for adding the individual 
		## spell pool containers
func create_pool_container(): 
	var my_spell_container = Character_Spell_Container_Node.instance()
	my_spell_container.set_name(self.get_name() + "_spell_pools")
	Game_Manager.add_child(my_spell_container)
	return my_spell_container

func set_up_pool_containers():
	set_spell_container(create_pool_container())
	for i in len(get_equipped_spells()):
		var pool_container = Pool_Container.instance()
		pool_container.set_name("pool_container_" + str(i))
		get_spell_container().add_child(pool_container)
		pool_node_list.push_back(pool_container)

func set_spell_container(node):
	spell_container = node
	
func get_spell_container():
	return spell_container

func get_equipped_spells():
	return equipped_spells

func get_pool_node_list():
	return pool_node_list

func instantiate_projectile_pool(projectile, pool_name, slot, spell_attributes):
	for i in pool_node_list[slot].get_children():
		i.queue_free()
	var new_pool = Pool.new(POOL_SIZE, pool_name, projectile, spell_attributes, self)
	new_pool.attach_to_node(pool_node_list[slot])
	return new_pool

func clear_container_node(slot):
	for i in pool_node_list[slot].get_children():
		i.queue_free()
### this should be defunct and turned into one generic function that will be able to instantiate each pool 
### separately when necessary
#func projectile_pool_setup():
#	fireball_pool = Pool.new(POOL_SIZE, FIREBALL_POOL_NAME, Fireball)
#	fireball_pool.attach_to_node(Game_Manager)
#
#	wave_pool = Pool.new(POOL_SIZE, WAVE_POOL_NAME, Wave)
#	wave_pool.attach_to_node(Game_Manager)
#
#	iceblast_pool = Pool.new(POOL_SIZE, ICEBLAST_POOL_NAME, Iceblast)
#	iceblast_pool.attach_to_node(Game_Manager)	
