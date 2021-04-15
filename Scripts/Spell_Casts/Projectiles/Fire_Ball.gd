extends "res://Scripts/Base_Classes/Base_Projectile.gd"

var burn_power = 0
var burn_duration = 0

onready var animated_sprite = $AnimatedSprite
onready var smoke = $Smoke
onready var steam = $Steam

var alive = true

func _ready():
	add_to_group('Fireballs')
	animated_sprite.play("Fly")
	animated_sprite.connect("animation_finished", self, 'end_explosion')
	
func _process(delta):
	if !alive and steam.emitting == false:
		queue_free()

#gets called when projectile enters body. called from parent class on_body_entered function
func impact_body(body):
	#.impact_body(body)
	body.take_damage(attributes['power'])
	body.burn(attributes['burn_power'], attributes['burn_duration'])
	knock_back(body, movement_direction)
	explode()

func impact_wall(body):
	explode()
	
func explode():
	stop_projectile()
	self.collision_shape.set_deferred("disabled", true)
	animated_sprite.play("Explode")
	smoke.set_lifetime(.35) 
	smoke.emitting = false
	
func put_out():
	stop_projectile()
	self.collision_shape.set_deferred("disabled", true)
	queue_free()
#	steam.set_emitting(true)
#	alive = false
#	animated_sprite.visible = false
	
func end_explosion():
	if animated_sprite.get_animation() == "Explode":
		queue_free()

func impact_spell(area):
	if area.is_in_group('Fireballs'):
		explode()
