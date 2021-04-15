extends "res://Scripts/Base_Classes/Base_Projectile.gd"


onready var Splash = preload("res://Scenes/Particles/Splash.tscn")
onready var Evaporate_Particle = preload("res://Scenes/Particles/Evaporate.tscn")
onready var wave_base = $Wave_Base
onready var foam = $Foam
onready var raycast_array = $Raycast_Container.get_children()


var foam_timer : Timer
var can_wall_splash_timer : Timer
var can_wall_splash = false

func _ready():
	foam_timer = Timer.new()
	add_child(foam_timer)
	foam_timer.one_shot = true
	foam_timer.connect("timeout", self, "start_foam")
	foam_timer.start(.3)
	
	can_wall_splash_timer = Timer.new()
	add_child(can_wall_splash_timer)
	can_wall_splash_timer.one_shot = true
	can_wall_splash_timer.connect("timeout", self, "set_can_wall_splash")
	can_wall_splash_timer.start(.1)
	
	for cast in raycast_array:
		cast.add_exception(self)
	
func start_foam():
	foam.emitting = true
	
func set_can_wall_splash():
	can_wall_splash = true
	
func impact_body(body):
	knock_back(body, movement_direction)
	if can_wall_splash:
		spawn_splash(body)
	body.end_burn()

func impact_wall(body):
	if can_wall_splash:
		spawn_splash(body)
	queue_free()

func spawn_splash(body):
	var impact_normal: Vector2
	var impact_point: Vector2
	for cast in raycast_array:
		if cast.get_collider() == body:
			impact_normal = cast.get_collision_normal()
			impact_point = cast.get_collision_point()
			break
	var splash_direction = (movement_direction - 2 * (movement_direction * impact_normal) * impact_normal)
	var splash = Splash.instance()
	splash.global_position = impact_point
	splash.process_material.set_direction(Vector3(splash_direction.x, splash_direction.y, 0))
	Game_Manager.add_child(splash)

func on_body_entered(body):
	.on_body_entered(body)

func on_body_exited(body):
	pass

func impact_spell(area):
	if area.is_in_group('Fireballs'):
		print("impacted fireball")
		area.put_out()
		evaporate(area.global_position)
		
func evaporate(heat_position):
	set_scale(get_scale() * .9)
	var evaporate_particle = Evaporate_Particle.instance()
	evaporate_particle.global_position = heat_position
	Game_Manager.add_child(evaporate_particle)
	#evaporate_particle.emitting = true
	attributes["push_power"] *= .9
	#queue_free()
