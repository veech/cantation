extends KinematicBody2D

export var max_speed = 150
var speed 
var push = Vector2.ZERO
var knockback = Vector2.ZERO
var knockback_recovery

onready var Shader_Material = preload("res://Materials/Character_Material.tres")
#onready var shader_material = $AnimatedSprite.Shader_Material
onready var animated_sprite = $AnimatedSprite
var facing_direction: Vector2 = Vector2.DOWN

export var max_health: int = 100
export var armor_rating: int = 0
export var fire_resistance: int = 0
export var freeze_resistance: int = 0
export var push_resistance: int = 0
export var default_knockback_recovery: float = .1

var layer
export var push_sensitivity: int = 50
export var knockback_sensitivity: int = 150

onready var health_bar = get_node("Health_Bar_Container/Health_Bar")
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
const Burn_Anim = preload("res://Scenes/Non-Projectile_Spells/Burn_Anim.tscn")

var burn_anim
var shock_anim
var equipped_spells = []

var Shock_Timer = preload("res://Scenes/Utilities/Shock_Timer.tscn")
var shock_timer: Timer

var cast_anim_timer: Timer

var in_cast = false
var starting_wind_cast = false
var in_wind_cast = false
var ending_wind_cast = false

func _ready():
	#Shader_Material.shader.set_local_to_scene(true)
#	animated_sprite.set_material(Shader_Material)
#	animated_sprite.material.set_local_to_scene(true)
#	animated_sprite.material.shader.set_local_to_scene(true)
#	print(animated_sprite.material.is_local_to_scene())
#	animated_sprite.material.set_shader_param("multiply_color", Color(1, 1, 1, 1))
#	print(animated_sprite.material)
	reset_shader()
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	reset_knockback_recovery()
	reset_speed()
	create_shock_node()
	create_burn_node()
	shock_timer = Shock_Timer.instance()
	self.add_child(shock_timer)
	shock_timer.connect('timeout', self, 'end_shock')

	animated_sprite.connect('animation_finished', self, "on_animation_finished")

	cast_anim_timer = Timer.new()
	add_child(cast_anim_timer)
	cast_anim_timer.set_one_shot(true)
	cast_anim_timer.connect("timeout", self, "on_animation_finished")

func _physics_process(delta):
	move_character(delta)
	if frozen:
		frozen_time_remaining -= delta
		if frozen_time_remaining <= 0:
			end_freeze()
	if burned:
		burn_time_remaining -= delta
		burn_timer += delta
		if burn_timer >= 1:
			take_damage(burn_damage)
			burn_timer = 0
		if burn_time_remaining <= 0:
			end_burn()
	animator(velocity)

func reset_shader():
	animated_sprite.material.set_shader_param("multiply_color", Color(1, 1, 1, 1))

func multiply_shader(color):
	animated_sprite.material.set_shader_param("multiply_color", color)

func create_burn_node():
	burn_anim = Burn_Anim.instance()
	self.add_child(burn_anim)
	burn_anim.set_visible(false)
	
func create_shock_node():
	shock_anim = Shock_Anim.instance()
	self.add_child(shock_anim)
	shock_anim.set_visible(false)

func animator(direction: Vector2):
	if direction != Vector2.ZERO:
		if in_cast:
			animated_sprite.play("Cast_W_" + get_animation_direction(direction))
		elif starting_wind_cast:
			animated_sprite.play("Uber_In_" + get_binary_animation_direction(direction))
		elif in_wind_cast:
			animated_sprite.play("Uber_" + get_binary_animation_direction(direction))
		elif ending_wind_cast:
			animated_sprite.play("Uber_Out_" + get_binary_animation_direction(direction))
		else:
			animated_sprite.play("Walk_" + get_animation_direction(direction))
			facing_direction = direction
	else:		
		if in_cast:
			print("Stationary casts not yet set up")
		elif starting_wind_cast:
			animated_sprite.play("Uber_In_" + get_binary_animation_direction(facing_direction))
		elif in_wind_cast:
			animated_sprite.play("Uber_" + get_binary_animation_direction(facing_direction))
		elif ending_wind_cast:
			animated_sprite.play("Uber_Out_" + get_binary_animation_direction(facing_direction))
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

func get_binary_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y > 0:
		return "Down"
	else:
		return "Up"

#I just realized I could have done this more elegantly
#I should have just checked for the current animation name instead of making all of these bools
#I might fix it later. might just plan to do better on the next project
func on_animation_finished():
	if in_cast:
		in_cast = false
	elif starting_wind_cast:
		starting_wind_cast = false
		in_wind_cast = true
	elif ending_wind_cast:
		ending_wind_cast = false
	else:
		return

func cast_animation(spell):
	pass

func move_character(delta):
	move_and_slide((velocity * speed) + push + knockback)
	#this is causing an issue with the way wind is handled
	#but it's necessary for knockback recovery
	knockback = lerp(knockback, Vector2.ZERO, knockback_recovery)
	
func knockback(push_direction, push_power):
	knockback = push_direction * push_power * knockback_sensitivity
	
func reset_knockback_recovery():
	knockback_recovery = default_knockback_recovery

func nullify_knockback_recovery():
	knockback_recovery = 0
	
func start_push(push_direction, push_power):
	push += push_direction * push_power * push_sensitivity
	
func end_push(push_direction, push_power):
	push -= push_direction * push_power * push_sensitivity
	#reset_push()
	
func reset_push():
	push = Vector2.ZERO
	
func burn(burn_power, burn_duration):
	self.burn_damage = burn_power
	burn_time_remaining = burn_duration
	burned = true
	burn_anim.set_visible(true)
	if frozen:
		end_freeze()
	
func end_burn():
	burned = false
	burn_anim.set_visible(false)
	
func freeze(freeze_power, freeze_duration):
	speed = (max_speed * 1/freeze_power)
	frozen_time_remaining = freeze_duration
	frozen = true
	multiply_shader(Color(0, 1, 1, 1))
	
func end_freeze():
	reset_shader()
	reset_speed()
	frozen = false
	
func shock(shock_time):
	shock_timer.stop()
	shocked = true
	shock_anim.set_visible(true)
	shock_timer.start(shock_time)
		#attributes should choose which anim is played somehow.
		#a timer could work too. I just would need to call stop on the timer and then start it up again.
	shock_anim.play("shock_medium")
	nullify_speed()
	animated_sprite.set_speed_scale(7)
	
func end_shock():
	shock_anim.set_visible(false)
	shocked = false
	reset_speed()
	animated_sprite.set_speed_scale(1)
	
func take_damage(damage):
	var health_loss = damage - armor_rating
	current_health -= health_loss
	update_health_bar()
	if current_health <= 0:
		death()

func reset_speed():
	print("max speed is ", max_speed)
	speed = max_speed
	print("my speed is", speed)

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

func update_health_bar():
	health_bar.value = current_health
