extends RigidBody2D

var explosion = preload("res://Scenes/LadderExplosion.tscn")

@onready var climb_follow = $ClimbPath/ClimbFollow
@onready var climb_follow_2 = $ClimbPath2/ClimbFollow
@onready var ray_cast = $Marker2D
@onready var ray_cast_2 = $Marker2D2
@onready var teller = $Teller
@onready var world = get_tree().current_scene

@export var should_stabilize = true
@export var climbing_time = 2.1

var countdown_on = false
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
	var distance = $Center.global_position.distance_to(Global.player.global_position)
	if placed and !being_climbed:
		if distance < 100.0:
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
		spawn_effect()
		Global.player.placed_ladder = null
		self.queue_free()
	var distance = $Center.global_position.distance_to(Global.player.global_position)
	if has_stabilized:
		if distance < 80.0 and !being_climbed:
			if !message_vis:
				message_vis = true
				world.show_down_message("PRESS SPACE TO CLIMB","ffffff")
			teller.show()
			can_be_climbed = true
		else:
			teller.hide()
			if message_vis:
				message_vis = false
				world.hide_down_message()
			can_be_climbed = false
	if countdown_on:
		$TextureProgressBar.value = $Countdown.time_left
	if has_stabilized and get_node_or_null("TextureProgressBar") != null and !countdown_on:
		start_countdown()

func start_timer():
	$Timer.start()

func _on_timer_timeout():
	if linear_velocity.is_zero_approx():
		if should_stabilize:
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

func _physics_process(delta):
	if $RayCast2D.is_colliding() and $RayCast2D3.is_colliding() or $RayCast2D2.is_colliding() and $RayCast2D4.is_colliding():
		if should_stabilize:
			print("i've stopped")
			linear_velocity = Vector2.ZERO
			has_stabilized = true
			freeze = true
		$RayCast2D.enabled = false
		$RayCast2D3.enabled = false
		$RayCast2D2.enabled = false
		$RayCast2D4.enabled = false

func activate_rays():
	$RayCast2D.enabled = true
	$RayCast2D3.enabled = true
	$RayCast2D2.enabled = true
	$RayCast2D4.enabled = true

func start_countdown():
	$Countdown.start()
	countdown_on = true

func _on_countdown_timeout():
	CursorFollower.hide_tips()
	world.hide_down_message()
	spawn_effect()
	Global.player.placed_ladder = null
	self.queue_free()

func spawn_effect():
	var effect_inst = explosion.instantiate()
	effect_inst.global_position = $Center.global_position
	effect_inst.global_rotation = self.global_rotation
	get_tree().current_scene.add_child(effect_inst)
	effect_inst.emitting = true
