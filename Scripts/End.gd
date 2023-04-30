extends Control

func _ready():
	Global.timer_on = false
	$Label3.text = str(Global.text)
