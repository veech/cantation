extends Node2D


var enemies = Array()
var timer
var update_interval = .3

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		enemies.push_back(child)
	for enemy in enemies:
		print(enemy)

	timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(false)
#	timer.set_timer_process_mode(TIMER_PROCESS_FIXED)
	timer.set_wait_time(update_interval)
	timer.connect("timeout", self, "update_goal")
	timer.start()


func _process(delta):
	pass

func update_goal():
	print("updating goals")
	for enemy in enemies:
		enemy.calculate_goal()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
