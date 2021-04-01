#So this enemy manager is basically functional rn.
#however I need it to calculate a radius to spawn enemies
#Enemies will be spawned along this radius
#depending on the value of the radius, I need a max number of enemies calculated
#that will take into consideration the size of the enemies and spacing so they dont overlap


extends Node2D


var enemies = Array()
var timer
var update_interval = .3

var player_detected = false
#Temp var for naming the spawned enemies
var spawn_point_name = "Enemy_spawn"


export(int, 10, 100) var spawn_radius = 10
export var enemies_spawned = 12

var min_spawn_angle: float
var tallest_enemy_height: float = 32
var enemy_width: float = 16

onready var enemy_container = $Enemy_Container
onready var Enemy = preload("res://Scenes/Enemies/Enemy.tscn")

func _ready():
	spawn_enemies()
	
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(false)
#	timer.set_timer_process_mode(TIMER_PROCESS_FIXED)
	timer.set_wait_time(update_interval)
	timer.connect("timeout", self, "update_goal")
	timer.start()

func spawn_enemies():
	var max_enemies = calculate_max_enemies()
	if enemies_spawned > max_enemies:
		enemies_spawned = max_enemies
	for i in range(enemies_spawned):
		var new_spawn = Enemy.instance()
		new_spawn.set_name(spawn_point_name + "_" + str(i))
		$Enemy_Container.add_child(new_spawn)
		#new_spawn.position = calculate_spawn_position(i)
		if new_spawn.extents.y*2 > tallest_enemy_height:
			tallest_enemy_height = new_spawn.extents.y*2
		enemies.push_back(new_spawn)
	print("length of enemies in container ", len(enemies))
	place_enemies()

func place_enemies():
	var placement_angle_interval = (2*PI)/len(enemies)
	var placement_angle = placement_angle_interval
	for enemy in enemies:
		print("Placement angle is ", placement_angle)
		enemy.position = Vector2((spawn_radius * cos(placement_angle)), (spawn_radius * sin(placement_angle)))
		placement_angle += placement_angle_interval
		
		print("I was placed at ", enemy.global_position)

func calculate_circle():
	min_spawn_angle = asin(tallest_enemy_height/spawn_radius)
	print("min angle is ", min_spawn_angle)

func calculate_max_enemies():
	var max_enemies: int
	if spawn_radius < enemy_width:
		max_enemies = 1
	elif spawn_radius < tallest_enemy_height:
		max_enemies = 2
	else:
		min_spawn_angle = asin(tallest_enemy_height/spawn_radius)
		var full_circle = PI * 2
		var num_of_angles = full_circle/min_spawn_angle
		max_enemies = int(num_of_angles)	
	print("Max enemies: ", max_enemies)
	return max_enemies

func update_goal():
	print("updating goals")
	for i in len(enemies):
		if enemies[i] != null:
			enemies[i].calculate_goal()

func calculate_spawn_position(index):
	var starting_position = spawn_radius
	var spawn_interval = spawn_radius / (enemies_spawned+1)
	return Vector2((spawn_interval - (spawn_interval * index)), 0)
	
	
