extends Node

var player = null
var has_delivered_before = false
var saw_deletion_tip = false
var num_of_deliveries = 0
var show_level_thing = true

var time = 0
var timer_on = false
var text = 0

func _process(delta):
	if(timer_on):
		time += delta
	
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time,60*60) / 60
	var time_passed = "%02d : %02d : %03d" % [mins,secs,mils]
	
	text = time_passed
