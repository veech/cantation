extends Particles2D

func _ready():
	emitting = true
	set_scale(Vector2(3,3))

func _process(delta):
	if emitting == false:
		queue_free()
