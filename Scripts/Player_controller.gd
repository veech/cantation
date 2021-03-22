extends "res://Scripts/Base_Classes/Base_Character.gd"


onready var inventory = get_node("/root/Inventory_UI").get_child(0)
onready var spell_set = get_node("/root/Inventory_UI/Inventory/Spells_Set")

var input: Vector2
var facing_direction = Vector2(0,1)

##TESTING
#this would probably be better if it changed dynamically with the length of the spell_set.slots length
var equipped_spells = []
var current_spell_slot = 0
###TESTING

func _ready():
	set_collision_layer_bit(1, true)
	equipped_spells.resize(len(spell_set.slots))
###TESTING
	### this should be broken up into individual scripts for each spell and be called at the point of equipping the spell
	projectile_pool_setup()###
	#######################
	
	for i in range(len(spell_set.slots)):
		var spell_slot = spell_set.slots[i]
		if spell_slot:
			spell_slot.connect("set_spell", self, "set_equipped_spell")
###TESTING

func _physics_process(delta):
	get_input_axis()
	_animate()

func get_input_axis():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = input.normalized()
	
	_set_facing_direction(input)

func _input(event):
	if event.is_action_pressed("Cast"):
		if get_current_spell() != null:
			get_current_spell().cast(self, get_global_mouse_position())
		else:
			print("No active spell to cast")
	####TESTING
	if event.is_action_pressed("advance_current_spell"):
		set_current_spell(current_spell_slot + 1)
		print("Active spell is spell: ", current_spell_slot + 1)	
	####TESTING

func _set_facing_direction(input):
	if input.x != 0 && input.y == 0: 
		facing_direction.x = input.x
		facing_direction.y = 0
		
	if input.x == 0 && input.y != 0:
		facing_direction.x = 0
		facing_direction.y = input.y
	
func _animate():
	var in_motion: bool = velocity.x != 0 || velocity.y != 0
	
	if in_motion: _play_motion_animation()
	else: _play_idle_animation()
	
func _play_motion_animation():
	if facing_direction.y < 0:
		$AnimatedSprite.play("up_walk")
	elif facing_direction.y > 0:
		$AnimatedSprite.play("down_walk")
	elif facing_direction.x < 0:
		$AnimatedSprite.play("left_walk")
	elif facing_direction.x > 0:
		$AnimatedSprite.play("right_walk")
	
func _play_idle_animation():
	if facing_direction.y < 0:
		$AnimatedSprite.play("up_idle")
	elif facing_direction.y > 0:
		$AnimatedSprite.play("down_idle")
	elif facing_direction.x < 0:
		$AnimatedSprite.play("left_idle")
	elif facing_direction.x > 0:
		$AnimatedSprite.play("right_idle")




#####TESTING
# I think all this code needs to be moved to the BaseCharacter script.
# Probably the pools should be set up at the point of equipping a spell and destroyed at the point of unequipping.
# if this proves too expensive, then they should be instanced from the beginning
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
var fireball_pool : Pool
const Wave_Launcher = preload("res://Scripts/Spell_Casts/Wave_Launcher.gd")
var wave_pool : Pool
const Iceblast_Launcher = preload("res://Scripts/Spell_Casts/Iceblast_Launcher.gd")
var iceblast_pool: Pool

#Non-projectile Spell Scripts
const Summon_Sword = preload("res://Scripts/Spell_Casts/Summon_Sword.gd")
const Wind_Spell = preload("res://Scripts/Spell_Casts/Wind_Spell.gd")
const Lightning_Spell = preload("res://Scripts/Spell_Casts/Lightning_Spell.gd")
##### up to this point everything should be in base character


### next three functions can remain in the playercontroller for now
func set_equipped_spell(spell, slot):
	equipped_spells[slot] = instantiate_spell_caster(spell)

func set_current_spell(spell_slot):
	current_spell_slot = spell_slot % 4

func get_current_spell():
	return equipped_spells[current_spell_slot]


### this should be in the basecharacter class and each branch of the switch statement should 
### also instance the appropriate pool scenes
func instantiate_spell_caster(item):
	if !item:
		return null
	match item.attributes["spell_type"]:
		Global.SPELLS.FIRE:
			var fireball_launcher = Fireball_Launcher.new()
			fireball_launcher.set_attributes(item.attributes)
			fireball_launcher.set_spell_pool(fireball_pool)
			return fireball_launcher
		Global.SPELLS.WATER:
			var wave_launcher = Wave_Launcher.new()
			wave_launcher.set_attributes(item.attributes)
			wave_launcher.set_spell_pool(wave_pool)
			return wave_launcher
		Global.SPELLS.ICE:
			var iceblast_launcher = Iceblast_Launcher.new()
			iceblast_launcher.set_attributes(item.attributes)
			iceblast_launcher.set_spell_pool(iceblast_pool)
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

### this should be defunct and turned into one generic function that will be able to instantiate each pool 
### separately when necessary
func projectile_pool_setup():
	fireball_pool = Pool.new(POOL_SIZE, FIREBALL_POOL_NAME, Fireball)
	fireball_pool.attach_to_node(Game_Manager)

	wave_pool = Pool.new(POOL_SIZE, WAVE_POOL_NAME, Wave)
	wave_pool.attach_to_node(Game_Manager)
	
	iceblast_pool = Pool.new(POOL_SIZE, ICEBLAST_POOL_NAME, Iceblast)
	iceblast_pool.attach_to_node(Game_Manager)
