extends RigidBody2D

@onready var world = get_tree().current_scene

var speed = 100
var wheels = []
var turned_on = false
var can_turn_on = false

func _ready():
	wheels = get_tree().get_nodes_in_group("wheel")

func _physics_process(delta):
	if turned_on:
		for wheel in wheels:
			wheel.apply_torque_impulse(speed)
		if !$drive.playing:
			$drive.play()
	else:
		$drive.stop()
	if Input.is_action_just_pressed("climb") and can_turn_on:
		$RayCast2D.enabled = false
		$RayCast2D2.enabled = false
		turned_on = !turned_on
		await(get_tree().create_timer(1.0).timeout)
		$RayCast2D.enabled = true
		$RayCast2D2.enabled = true
	if $RayCast2D.is_colliding():
		speed = -100
		turned_on = false
	if $RayCast2D2.is_colliding():
		speed = 100
		turned_on = false

func _on_area_2d_body_entered(body):
	world.show_down_message("PRESS SPACE TO RIDE","ffffff")
	can_turn_on = true

func _on_area_2d_body_exited(body):
	world.hide_down_message()
	can_turn_on = false
