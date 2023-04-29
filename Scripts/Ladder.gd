extends RigidBody2D

@onready var climb_follow = $ClimbPath/ClimbFollow
@onready var climb_follow_2 = $ClimbPath2/ClimbFollow

@onready var ray_cast = $Marker2D
@onready var ray_cast_2 = $Marker2D2

@onready var teller = $Teller

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
		can_remove = true
		self.modulate = Color("ff0000")

func _on_mouse_exited():
	if placed and !being_climbed:
		can_remove = false
		self.modulate = Color("ffffff")

func reset_removal():
	can_remove = false
	self.modulate = Color("ffffff")

func _process(delta):
	if Input.is_action_just_pressed("right_click") and can_remove:
		Global.player.placed_ladder = null
		self.queue_free()
	var distance = $Center.global_position.distance_to(Global.player.global_position)
	if has_stabilized:
		if distance < 80.0 and !being_climbed:
			teller.show()
			can_be_climbed = true
		else:
			teller.hide()
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
