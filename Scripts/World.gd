extends Node2D

@onready var up_message = $UI/UpMessage
@onready var down_message = $UI/DownMessage
@onready var ladder_controls = $UI/LadderControls
@onready var grid = $Bg/Grid

@export var level = 1
@export var level_sub = ""
@export var next_level = ""

var has_delivered = false

var countdown_ladder = preload("res://Scenes/LadderCountdown.tscn")
var normal_ladder = preload("res://Scenes/Ladder.tscn")
var big_ladder = preload("res://Scenes/LadderBig.tscn")

func _ready():
	Global.timer_on = true
	up_message.scale = Vector2(1,0)
	down_message.scale = Vector2(1,0)
	ladder_controls.scale = Vector2(0,1)
	$UI/LevelMessage.scale = Vector2(1,0)
	grid.scale = Vector2(1,0)
	if Global.show_level_thing:
		await(get_tree().create_timer(1).timeout)
		popup_level()

func show_up_message(text):
	up_message.text = text
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(up_message,"scale",Vector2(1,1),0.15)

func hide_up_message():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(up_message,"scale",Vector2(1,0),0.15)

func show_down_message(text,color="ffffff"):
	down_message.text = text
	down_message.modulate = color
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(down_message,"scale",Vector2(1,1),0.15)

func hide_down_message():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(down_message,"scale",Vector2(1,0),0.15)

func popup_down_message(text,color="ffffff"):
	down_message.text = text
	down_message.modulate = Color(color)
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(down_message,"scale",Vector2(1,1),0.15)
	tween.tween_interval(1.0)
	tween.tween_property(down_message,"scale",Vector2(1,0),0.15)

func show_controls():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(ladder_controls,"scale",Vector2(1,1),0.2)

func hide_controls():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(ladder_controls,"scale",Vector2(0,1),0.2)

func show_grid():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(grid,"scale",Vector2(1,1),0.25)

func hide_grid():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(grid,"scale",Vector2(1,0),0.25)

func popup_level():
	$UI/LevelMessage.text = "Level " + str(level)
	$UI/LevelMessage/LevelMessage2.text = '"' + level_sub + '"'
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($UI/LevelMessage,"scale",Vector2(1,1),0.15)
	tween.tween_interval(3.0)
	tween.tween_property($UI/LevelMessage,"scale",Vector2(1,0),0.15)


func _on_change_level_body_entered(body):
	if body.name == "Player":
		if has_delivered:
			TransitionScene.change_scene_to(next_level)
			Global.show_level_thing = true
		else:
			popup_down_message("MAKE SURE TO GIVE PEOPLE THEIR PACKAGES","ff0000")


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.ladder = countdown_ladder

func _on_area_2d_2_body_entered(body):
	if body.name == "Player":
		body.ladder = normal_ladder
		body.friction = 0.005


func _on_area_2d_3_body_entered(body):
	if body.name == "Player":
		body.friction = 0.3

func _on_area_2d_4_body_entered(body):
	if body.name == "Player":
		body.ladder = big_ladder

func _on_area_2d_5_body_entered(body):
	if body.name == "Player":
		body.ladder = countdown_ladder
