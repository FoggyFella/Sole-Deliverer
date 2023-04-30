extends Control

func _ready():
	await(get_tree().create_timer(0.5).timeout)
	$AnimationPlayer.play("Intro")

func _on_animation_player_animation_finished(anim_name):
	TransitionScene.change_scene_to("res://Scenes/Intro.tscn")
