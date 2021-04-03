extends KinematicBody2D

export var max_speed = 150
var speed
var push = Vector2.ZERO
onready var animated_sprite = $AnimatedSprite
var facing_direction: Vector2 = Vector2.DOWN

export var max_health: int = 100
export var armor_rating: int = 0
export var fire_resistance: int = 0
export var freeze_resistance: int = 0
export var push_resistance: int = 0
export var default_push_recovery: float = .1
var push_recovery
var layer
export var push_sensitivity: int = 100

var current_health = max_health
var frozen = false
var burned = false

var frozen_time_remaining = 0
var burn_time_remaining = 0
var burn_damage = 0
var burn_timer = 0
var shocked = false
var can_shoot = true

var velocity: Vector2 = Vector2.ZERO

# Spell_Casters
const Fireball_Launcher = preload("res://Scripts/Spell_Casters/Fireball_Launcher.gd")
const Wave_Launcher = preload("res://Scripts/Spell_Casters/Wave_Launcher.gd")
const Iceblast_Launcher = preload("res://Scripts/Spell_Casters/Iceblast_Launcher.gd")
const Sword_Summoner = preload("res://Scripts/Spell_Casters/Sword_Summoner.gd")
const Wind_Caster = preload("res://Scripts/Spell_Casters/Wind_Caster.gd")
const Lightning_Caster = preload("res://Scripts/Spell_Casters/Lightning_Caster.gd")
	
const Shock_Anim = preload("res://Scenes/Non-Projectile_Spells/Shock_Anim.tscn")
var shock_anim
var equipped_spells = []

var Shock_Timer = preload("res://Scenes/Utilities/Shock_Timer.tscn")
var shock_timer: Timer

func _ready():
	reset_push_recovery()
	reset_speed()
	create_shock_node()
	shock_timer = Shock_Timer.instance()
	self.add_child(shock_timer)
	shock_timer.connect('timeout', self, 'end_shock')

func create_shock_node():
	shock_anim = Shock_Anim.instance()
	self.add_child(shock_anim)
	
func _physics_process(delta):
	move_character(delta)
	if frozen:
		frozen_time_remaining -= delta
		if frozen_time_remaining <= 0:
			frozen = false
			reset_speed()
			print("No longer frozen")
	if burned:
		burn_time_remaining -= delta
		burn_timer += delta
		if burn_timer >= 1:
			current_health -= burn_damage
			burn_timer = 0
			print("Burn damage!: current health: ", current_health)
		if burn_time_remaining <= 0:
			burned = false
	animator(velocity)

func animator(direction: Vector2):
	if direction != Vector2.ZERO:
		animated_sprite.play("Walk_" + get_animation_direction(direction))
		facing_direction = direction
	else:		
		animated_sprite.play("Idle_" + get_animation_direction(facing_direction))

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.x <= -0.707:
		return "Left"
	elif norm_direction.x >= 0.707:
		return "Right"
	elif norm_direction.y >= 0.707:
		return "Down"
	elif norm_direction.y <= -0.707:
		return "Up"
	return "Down"
	
func move_character(delta):
	move_and_slide((velocity * speed) + push)
	push = lerp(push, Vector2.ZERO, push_recovery)
	
func start_push(push_direction, push_power):
	print("push called")
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
	
func shock(shock_time):
	shock_timer.stop()
	shocked = true
	shock_anim.set_visible(true)
	shock_timer.start(shock_time)
		#attributes should choose which anim is played somehow.
		#a timer could work too. I just would need to call stop on the timer and then start it up again.
	shock_anim.play("shock_medium")
	nullify_speed()
	
func end_shock():
	shock_anim.set_visible(false)
	shocked = false
	reset_speed()
	
func take_damage(damage):
	var health_loss = damage - armor_rating
	current_health -= health_loss
	print("Damage taken!\n\nCurrent Health: ", current_health)
	if current_health <= 0:
		death()

func reset_push_recovery():
	push_recovery = default_push_recovery

func nullify_push_recovery():
	push_recovery = 0

func reset_speed():
	speed = max_speed

func nullify_speed():
	speed = 0

func death():
	print("Im ded")

#######################Spell casting code###########################
####################################################################
func instantiate_spell_caster(item, slot):
	if !item:
		return null
	match item.attributes["spell_type"]:
		Global.SPELLS.FIRE:
			return build_spell(Fireball_Launcher, item, slot)
		Global.SPELLS.WATER:
			return build_spell(Wave_Launcher, item, slot)
		Global.SPELLS.ICE:
			return build_spell(Iceblast_Launcher, item, slot)
		Global.SPELLS.SUMMONSWORD:
			return build_spell(Sword_Summoner, item, slot)
		Global.SPELLS.LIGHTNING:
			return build_spell(Lightning_Caster, item, slot)
		Global.SPELLS.WIND:
			return build_spell(Wind_Caster, item, slot)
		null:
			print("no spell_type assigned")
		_:
			print("This spell type is not in the switch statement")

func build_spell(spell_type, item, slot):
	var spell = spell_type.new()
	spell.set_attributes(item.attributes)
	spell.attributes['caster'] = self.get_name()
	spell.attributes['layer'] = self.layer
	return spell

func direction_from_to(position_a, position_b):
	var direction = position_b - position_a
	return direction.normalized()

func get_equipped_spells():
	return equipped_spells

func clear_container_node(slot):
	print("Cleared container node")

