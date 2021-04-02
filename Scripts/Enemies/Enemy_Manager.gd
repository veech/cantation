#If unexpected behavior is occuring with enemy movement and placement
#check the hard coded value for enemy height and width
#this should change eventually but idk how to do this
extends Node2D


var enemies = Array()
var timer
var update_interval = .3

var player_detected = false
var spawn_point_name = "Enemy_spawn"

export(int, 9, 100) var spawn_radius = 40
export var enemies_spawned = 12

var min_spawn_angle: float
var enemy_height: float = 32
var enemy_width: float = 16

onready var enemy_container = $Enemy_Container
export(PackedScene) onready var Enemy #= preload("res://Scenes/Enemies/Enemy.tscn")

func _ready():
	spawn_enemies()
	
	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(false)
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
		enemies.push_back(new_spawn)
	place_enemies()
	
func calculate_max_enemies():
	var max_enemies: int
	if spawn_radius < enemy_width:
		max_enemies = 1
	elif spawn_radius < enemy_height:
		max_enemies = 2
	else:
		min_spawn_angle = asin(enemy_height/spawn_radius)
		var full_circle = PI * 2
		var num_of_angles = full_circle/min_spawn_angle
		max_enemies = int(num_of_angles)	
	return max_enemies
	
func place_enemies():
	var placement_angle_interval = (2*PI)/len(enemies)
	var placement_angle = placement_angle_interval
	for enemy in enemies:
		enemy.position = Vector2((spawn_radius * cos(placement_angle)), (spawn_radius * sin(placement_angle)))
		placement_angle += placement_angle_interval

func update_goal():
	if player_detected:
		for i in len(enemies):
			if enemies[i] != null:
				enemies[i].calculate_goal()

