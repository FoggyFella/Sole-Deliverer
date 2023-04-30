extends Area2D

func _on_body_entered(body):
	if body.is_in_group("ladder"):
		body.queue_free()
		body.spawn_effect()
		Global.player.placed_ladder = null
	elif body.name == "Player":
		TransitionScene.reload_current_scene()
		Global.show_level_thing = false
