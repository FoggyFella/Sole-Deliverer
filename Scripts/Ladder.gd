extends RigidBody2D

@onready var climb_follow = $ClimbPath/ClimbFollow
@onready var climb_follow_2 = $ClimbPath2/ClimbFollow

@onready var ray_cast = $Marker2D
@onready var ray_cast_2 = $Marker2D2

@onready var teller = $Teller

@onready var world = get_tree().current_scene

var message_vis = false
var has_climbed = false
var player_rotated = false

var placed = false
var can_remove = false
var has_stabilized = false
var being_climbed = false
var can_be_climbed = false

var current_follow = null

func _on_mouse_entered():
	if placed and !being_climbed:
		CursorFollower.show_tips()
		can_remove = true
		self.modulate = Color("ff0000")

func _on_mouse_exited():
	if placed and !being_climbed:
		CursorFollower.hide_tips()
		can_remove = false
		self.modulate = Color("ffffff")

func reset_removal():
	CursorFollower.hide_tips()
	can_remove = false
	self.modulate = Color("ffffff")

func _process(delta):
	if Input.is_action_just_pressed("right_click") and can_remove:
		CursorFollower.hide_tips()
		world.hide_down_message()
		Global.player.placed_ladder = null
		self.queue_free()
	var distance = $Center.global_position.distance_to(Global.player.global_position)
	if has_stabilized:
		if distance < 80.0 and !being_climbed:
			if !message_vis:
				message_vis = true
				world.show_down_message("PRESS E TO CLIMB","ffffff")
			teller.show()
			can_be_climbed = true
		else:
			teller.hide()
			if message_vis:
				message_vis = false
				world.hide_down_message()
			can_be_climbed = false

func start_timer():
	$Timer.start()

func _on_timer_timeout():
	if linear_velocity.is_zero_approx():
		has_stabilized = true
		freeze = true
		print("i've stopped")
	else:
		start_timer()

func check_stuff():
	var distance = $Marker2D3.global_position.distance_to(Global.player.global_position)
	if distance > 40.0:
		print("on the other side")
		has_climbed = true
		climb_follow.progress_ratio = 1.0
		climb_follow_2.progress_ratio = 1.0
	else:
		has_climbed = false
