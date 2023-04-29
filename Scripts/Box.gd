extends Node2D

func _ready():
	randomize()
	$Sprite2D.frame = randi_range(0,$Sprite2D.hframes-1)
