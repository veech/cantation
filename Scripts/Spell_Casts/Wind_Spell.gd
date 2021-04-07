extends "res://Scripts/Base_Classes/Base_Spell.gd"

onready var collision_shape = $CollisionShape2D
onready var particles_a = $Particles2D_A
onready var particles_b = $Particles2D_B
onready var particles_c = $Particles2D_C

var particles = false
#var timer: Timer 

#this should def be set by the attributes
var spell_time = 10
var look_direction: Vector2
onready var caster = get_parent()
onready var particle_material = particles_c.get_process_material() 
var direction = Vector2.ZERO
func _ready():
	$Spell_Timer.connect("timeout", self, "deactivate_spell")
	print(caster.get_name())
	

func _physics_process(delta):
	#look_at(get_global_mouse_position())

	global_position = lerp(global_position, get_global_mouse_position(), .1)
	direction = lerp(direction, global_position.direction_to(caster.global_position), .6)
	particle_material.direction = Vector3(direction.x, direction.y, 0)
	#particle_material.set_direction(Vector3(direction.x, direction.y, 0))

func activate_wind(mouse_position):
	$Spell_Timer.stop()
	direction = get_global_mouse_position().direction_to(caster.global_position)
	particle_material.direction = Vector3(direction.x, direction.y, 0)
	global_position = get_global_mouse_position()
	var push_angle = rotation
	push_direction = Vector2(cos(push_angle), sin(push_angle))

	turn_on_particles(true)
	$Spell_Timer.start(spell_time)

func deactivate_spell():
	#turn_on_particles(false)
	queue_free()

func impact_body(body):
	body.nullify_push_recovery()
	knock_back(body, push_direction)
	
func exit_body(body):
	body.reset_push_recovery()

func _input(event):
	if event.is_action_released("Cast"):
		turn_on_particles(false)

func turn_on_particles(flag):
	if flag == true:
		particles_a.emitting = true
		particles_b.emitting = true
		particles_c.emitting = true
		print(particles_c.get_process_material().get_direction())
	else:
		particles_a.emitting = false
		particles_b.emitting = false
		particles_c.emitting = false
		
