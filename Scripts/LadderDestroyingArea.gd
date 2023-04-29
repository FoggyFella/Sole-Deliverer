extends Area2D

func _on_body_entered(body):
	if body.is_in_group("ladder"):
		body.queue_free()
		Global.player.placed_ladder = null
	elif body.name == "Player":
		get_tree().reload_current_scene()
