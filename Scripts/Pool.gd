extends Node

#const spell_obj = preload("res://Scenes/Spell.tscn")

var size
var scene
var obj_name
var spell_attributes = {}
#this is hacky. I need this to be set somehow by the level size maybe?
#or I just need to find a way to turn off all of the 
var pool_position = Vector2(-1000, -1000)

#objects in scene
var active_objects = {}

#objects not in scene
var inactive_objects = []


func _init(size, obj_name, scene, spell_attributes, caster):
	if scene == null:
		print("object not set for pool creation")
		return
		
	self.size = size
	self.obj_name = obj_name
	self.scene = scene
	self.spell_attributes = spell_attributes
	self.spell_attributes["caster"] = caster.get_name()
	construct()
	
func construct():
	for i in range(self.size):
		var s = self.scene.instance()
		s.set_name(obj_name + "_" + str(i))
		s.attributes = self.spell_attributes
		s.connect("killed", self, "on_killed")
		s.active = false
#		s.global_position = pool_position
		s.hide()
		inactive_objects.push_back(s)
	
func get_inactive_object():
	if inactive_objects.size() >= 1:
		var obj = inactive_objects.pop_back()
		if obj.active == true:
			print("Oops. tried to spawn active object")
			return null
		var n = obj.get_name()
		active_objects[n] = obj
		turn_on(obj)
		return obj
	return null

func attach_to_node(target_node):
	for i in active_objects.values():
		target_node.add_child(i)
	for i in inactive_objects:
		target_node.add_child(i)
		
func on_killed(target):
	turn_off(target)
	var name = target.get_name()
	var temp = active_objects.erase(name)
	inactive_objects.push_front(target)
	
func get_scene():
	return scene
	
func no_access():
	return
	
func turn_on(target):
	target.active = true
	#collision_shape is a var named in baseprojectile
	target.collision_shape.set_deferred("disabled", false)
	target.show()

func turn_off(target):
	target.active = false
	target.collision_shape.set_deferred("disabled", true)
	target.hide()
