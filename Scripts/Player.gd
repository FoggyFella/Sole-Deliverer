extends CharacterBody2D

@onready var world = $".."
@onready var sprite = $Sprite

var ladder = preload("res://Scenes/Ladder.tscn")
var placing_ladder = null
var placed_ladder = null

var is_climbing_over = false
var in_ladder_mode = false
var gravity = 13.0
@export var speed = 85.0
@export var inertia = 10.0
@export var hop = -120

func _ready():
	Global.player = self

func _physics_process(delta):
	if !is_on_floor() and !is_climbing_over:
		velocity.y += gravity
	var move_dir = Input.get_axis("move_left","move_right")
	if move_dir != 0 and !in_ladder_mode and !is_climbing_over:
		$Sprite.play("walk")
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("walk_rotation")
		rotate_sprite(move_dir)
		velocity.x = lerp(velocity.x,move_dir * speed,0.2)
	else:
		$AnimationPlayer.stop()
		if !is_climbing_over:
			$Sprite.play("idle")
		velocity.x = lerp(velocity.x,0.0,0.3)
#	if Input.is_action_just_pressed("hop") and is_on_floor() and !in_ladder_mode:
#		velocity.y += hop
	move_and_slide()
	apply_impulse_to_ladder()
	if !is_climbing_over:
		ladder_mode()
	if Input.is_action_just_pressed("climb"):
		climb_across()
	if is_climbing_over:
		self.global_position = placed_ladder.current_follow.global_position

func rotate_sprite(move_dir):
	if move_dir == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func apply_impulse_to_ladder():
	for i in get_slide_collision_count():
		var col  = get_slide_collision(i)
		var collider = col.get_collider()
		if collider.is_in_group("ladder"):
			collider.apply_central_impulse(-col.get_normal()*inertia)
			if !collider.has_stabilized:
				collider.start_timer()

func ladder_mode():
	if Input.is_action_just_pressed("ladder_mode") and placed_ladder == null:
		if !in_ladder_mode:
			in_ladder_mode = true
			world.show_controls()
			world.show_up_message("LADDER MODE")
			world.show_grid()
			placing_ladder = ladder.instantiate()
			placing_ladder.freeze = true
			placing_ladder.modulate = Color("ffffff80")
			placing_ladder.set_collision_mask_value(2,false)
			self.set_collision_mask_value(3,false)
			get_tree().current_scene.add_child(placing_ladder)
		else:
			in_ladder_mode = false
			placing_ladder.queue_free()
			world.hide_up_message()
			world.hide_grid()
			world.hide_controls()
	if in_ladder_mode:
		var distance_to_ladder = global_position.distance_to(get_global_mouse_position())
		placing_ladder.global_position.y = self.global_position.y
		if distance_to_ladder < 160.0:
			placing_ladder.global_position.x = get_global_mouse_position().x
		if Input.is_action_just_pressed("left_click"):
			in_ladder_mode = false
			world.hide_up_message()
			world.hide_controls()
			world.hide_grid()
			placing_ladder.freeze = false
			placing_ladder.modulate = Color("ffffff")
			placing_ladder.set_collision_mask_value(2,true)
			self.set_collision_mask_value(3,true)
			placed_ladder = placing_ladder
			placed_ladder.placed = true
			placing_ladder = null
			placed_ladder.activate_rays()
		if Input.is_action_just_pressed("rotate"):
			if placing_ladder.rotation_degrees == 0:
				placing_ladder.global_position.y -= 3
				placing_ladder.rotate(deg_to_rad(90.0))
			else:
				placing_ladder.global_position.y += 3
				placing_ladder.rotate(deg_to_rad(-90.0))
	if Input.is_action_just_pressed("ladder_mode") and placed_ladder != null:
		world.popup_down_message("YOU CAN HAVE ONLY ONE LADDER","ff0000")

func climb_across():
	if placed_ladder != null and placed_ladder.can_be_climbed:
		var rotation_without = abs(placed_ladder.rotation_degrees)
		if rotation_without < 60.0:
			$Sprite.play("climb")
		else:
			$Sprite.play("walk")
		$AnimationPlayer.stop()
		is_climbing_over = true
		placed_ladder.being_climbed = true
		placed_ladder.teller.hide()
		placed_ladder.reset_removal()
		placed_ladder.check_stuff()
		if placed_ladder.rotation_degrees < 0:
			$Sprite.flip_h = true
			placed_ladder.player_rotated = true
			self.rotation = placed_ladder.ray_cast.global_rotation
			placed_ladder.current_follow = placed_ladder.climb_follow_2
		else:
			$Sprite.flip_h = false
			placed_ladder.player_rotated = false
			self.rotation = placed_ladder.ray_cast_2.global_rotation
			placed_ladder.current_follow = placed_ladder.climb_follow
		if !placed_ladder.has_climbed:
			var tween = create_tween()
			tween.tween_property(placed_ladder.current_follow,"progress_ratio",1.0,2.1)
			await(tween.finished)
			placed_ladder.has_climbed = true
		else:
			placed_ladder.player_rotated = !placed_ladder.player_rotated
			$Sprite.flip_h = placed_ladder.player_rotated
			var tween = create_tween()
			tween.tween_property(placed_ladder.current_follow,"progress_ratio",0.0,2.1)
			await(tween.finished)
			placed_ladder.has_climbed = false
		is_climbing_over = false
		$Sprite.play("walk")
		placed_ladder.being_climbed = false
		self.rotation = 0.0
