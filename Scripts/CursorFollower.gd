extends Node2D

func _ready():
	$Label.hide()

func _process(delta):
	if $Label.visible:
		self.global_position = get_global_mouse_position()

func show_tips():
	$Label.show()
	
func hide_tips():
	$Label.hide()
