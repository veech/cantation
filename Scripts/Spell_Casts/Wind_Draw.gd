extends "res://Scripts/Base_Classes/Base_Spell.gd"

signal line_finished

onready var point_timer = $Point_Timer
onready var deactivate_timer = $Deactivation_Timer
onready var line2d = $Line2D
onready var Wind_Particles = preload("res://Scenes/Particles/Wind_Particles.tscn")
onready var Wind_Unit = preload("res://Scenes/Non-Projectile_Spells/Wind_Unit.tscn")

var drawing = false
var min_point_distance = 30
var duration = 10

func _ready():
	point_timer.connect("timeout", self, "update_line")
	point_timer.one_shot = false
	deactivate_timer.connect("timeout", self, "deactivate_wind")
	connect('line_finished', self, 'activate_wind')

func _physics_process(delta):
	
	if line2d.get_point_count() >= 10 and drawing == true:
		print("finished")
		emit_signal("line_finished")
	
func cast(mouse_position):
	drawing = true
	line2d.add_point(get_global_mouse_position())
	point_timer.start(.01)
	
func update_line():
	var previous_point = line2d.points[-1]
	var mouse_position = get_global_mouse_position()
	var distance_to_mouse = line2d.points[-1].distance_to(get_global_mouse_position())
	if distance_to_mouse >= min_point_distance:
		if distance_to_mouse >= min_point_distance * 2:
			print("adding more points in between")
			var num_of_points = int(distance_to_mouse / min_point_distance)
			var direction = previous_point.direction_to(mouse_position)
			for i in range(num_of_points):
				if i == 0:
					continue
				var new_point = previous_point + (direction * min_point_distance * i) 
				line2d.add_point(new_point)
		line2d.add_point(get_global_mouse_position())

func normalize_line(point_a, point_b):
	var distance_to_mouse = point_a.distance_to(point_b)
	if distance_to_mouse >= min_point_distance * 2:
		var num_of_points = int(distance_to_mouse / min_point_distance)
		var direction = point_a.direction_to(point_b)
		for i in range(num_of_points):
			if i == 0:
				continue
			var new_point = point_a + (direction * min_point_distance * i) 
			line2d.add_point(new_point)
	
func bisect(point_a, point_b):
	var distance_to_mouse = point_b - point_a
	var bisect_point = Vector2((distance_to_mouse.x * .5), (distance_to_mouse.y * .5))
	return bisect_point
	
func _input(event):
	if event.is_action_released("Cast") and drawing == true:
		emit_signal("line_finished")

func stop_drawing():
	point_timer.stop()
	drawing = false
	
	point_timer.stop()

func activate_wind():
	stop_drawing()
	for i in (len(line2d.points) - 1):
		var wind_unit = Wind_Unit.instance()
		wind_unit.global_position = line2d.points[i]
		add_child(wind_unit)
		wind_unit.look_at(line2d.points[i+1])
		wind_unit.set_attributes(attributes)
		wind_unit.look_direction = line2d.points[i+1].direction_to(line2d.points[i])
	line2d.visible = false
	deactivate_timer.start(duration)
	
func deactivate_wind():
	print('deactivate called')
	queue_free()

