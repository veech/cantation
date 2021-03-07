tool extends Area2D

enum Potion { HEALTH, MAGIC }
export (Potion) var type = Potion.HEALTH

func _ready():
	if type == Potion.HEALTH:
		$Sprite.region_rect.position.x = 16
	else:
		$Sprite.region_rect.position.x = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if type == Potion.HEALTH:
		$Sprite.region_rect.position.x = 16
	else:
		$Sprite.region_rect.position.x = 0

func _on_Potion_body_entered(body):
	if body.name == "Player":
		body.add_potion(type)
		get_tree().queue_delete(self)
