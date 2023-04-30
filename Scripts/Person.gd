extends Node2D

@onready var world = get_tree().current_scene

@export var dialogue_string = '[["You","Hey, is this Mr.Jeremy?",1],["MR.Jeremy","Yup, are you the delivery guy they were talking about?",0],["You","Yeah, here is your package!",1]]'

var box = preload("res://Scenes/Box.tscn")

var has_delivered = false
var dialogue = null
var can_speak = false

func _ready():
	$Label.hide()
	dialogue = JSON.parse_string(dialogue_string)

func _process(delta):
	if Input.is_action_just_pressed("speak") and can_speak:
		if !has_delivered:
			Dialogue.show_dialogue(dialogue)
		else:
			Dialogue.show_dialogue([["You","I've already delivered them their package",1]])
		can_speak = false
		await(Dialogue.finished)
		if !has_delivered:
			has_delivered = true
			world.has_delivered = true
			Global.has_delivered_before = true
			spawn_box()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		can_speak = true
		$Label.show()
		world.hide_down_message()

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		can_speak = false
		$Label.hide()

func spawn_box():
	var box_inst = box.instantiate()
	box_inst.global_position = $BoxPos.global_position
	get_tree().current_scene.add_child(box_inst)
