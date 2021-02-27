extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_accept"):
		toggle_visibility()
	
func toggle_visibility():
	if layer == 1:
		layer = -1
	else:
		 layer = 1
