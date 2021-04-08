extends "res://Scripts/Base_Classes/Base_Projectile.gd"

var burn_power = 0
var burn_duration = 0

onready var animated_sprite = $AnimatedSprite
onready var smoke = $Smoke

func _ready():
	animated_sprite.play("Fly")
	animated_sprite.connect("animation_finished", self, 'end_explosion')

#gets called when projectile enters body. called from parent class on_body_entered function
func impact_body(body):
	#.impact_body(body)
	body.take_damage(attributes['power'])
	body.burn(attributes['burn_power'], attributes['burn_duration'])
	knock_back(body, movement_direction)
	explode()

func impact_wall():
	explode()
	
func explode():
	stop_projectile()
	self.collision_shape.set_deferred("disabled", true)
	animated_sprite.play("Explode")
	smoke.set_lifetime(.35) 
	smoke.emitting = false
	
func end_explosion():
	if animated_sprite.get_animation() == "Explode":
		queue_free()
