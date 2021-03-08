extends Node

#const spell_obj = preload("res://Scenes/Spell.tscn")

var size
var scene
var obj_name

#objects in scene
var active_objects = {}

#objects not in scene
var inactive_objects = []


func _init(size, obj_name, scene):
	if scene == null:
		print("object not set for pool creation")
		return
		
	self.size = size
	self.obj_name = obj_name
	self.scene = scene
	construct()
	
func construct():
	for i in range(self.size):
		var s = self.scene.instance()
		s.set_name(obj_name + "_" + str(i))
		s.connect("killed", self, "on_killed")
		s.active = false
		turn_off(s)
		inactive_objects.push_back(s)
	
	
func get_inactive_object():
#	if inactive_objects.size() > 0:
#		var object = inactive_objects.pop_back()

	var ds = inactive_objects.size()
	if ds > 0:
		var obj = inactive_objects[ds - 1]
		
		if obj.active:
			print("Oops. tried to spawn active object")
			return null

		var n = obj.get_name()
		active_objects[n] = obj
		inactive_objects.pop_back()
		obj.active = true
		turn_on(obj)
		return obj

	print("Not enough" + obj_name + " objects in pool to spawn another")
	return null

func attach_to_node(target_node):
	for i in active_objects.values():
		target_node.add_child(i)
	for i in inactive_objects:
		target_node.add_child(i)
	
	
func on_killed(target):
	var name = target.get_name()
	target.active = false
	var temp = active_objects.erase(name)
	inactive_objects.push_front(target)
	turn_off(target)
	
func get_scene():
	return scene
	
func no_access():
	return
	
func turn_on(target):
	target.show()
	target.set_monitoring(true)

func turn_off(target):
	target.hide()
	target.set_monitoring(false)
	
	
	
