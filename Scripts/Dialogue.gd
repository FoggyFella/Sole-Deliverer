extends CanvasLayer

const CHAR_READ_RATE = 0.05
signal go_on
signal finished

var faces = [
	preload("res://Assets/People/jeremy.png"),
	preload("res://Assets/People/you.png"),
	preload("res://Assets/People/will.png"),
	preload("res://Assets/People/linda.png"),
	preload("res://Assets/People/jimmy.png")
]

func _ready():
	$Panel/Text.visible_ratio = 0.0
	$Panel/FaceAnchor/Face.hide()
	$Panel/Name.hide()
	$Panel.scale = Vector2(1,0)
	$Panel/Continue.hide()

func show_dialogue(text_array):
	get_tree().paused = true
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($Panel,"scale",Vector2(1,1),0.2)
	await(tween.finished)
	for text in text_array:
		$Panel/Continue.hide()
		var fella_name = text[0]
		var the_text = text[1]
		var face = faces[text[2]]
		$Panel/FaceAnchor/Face.texture = face
		$Panel/Name.text = fella_name
		$Panel/Text.text = the_text
		$Panel/FaceAnchor/Face.show()
		$Panel/Name.show()
		$AnimationPlayer.play("Speaking")
		var text_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		text_tween.tween_property($Panel/Text,"visible_ratio",1.0,len(the_text)*CHAR_READ_RATE)
		await(text_tween.finished)
		$Panel/FaceAnchor/Face.frame = 0
		$AnimationPlayer.stop()
		$Panel/Continue.show()
		await(go_on)
		$Panel/Text.visible_ratio = 0.0
	get_tree().paused = false
	var tween_2 = create_tween().set_trans(Tween.TRANS_CUBIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_2.tween_property($Panel,"scale",Vector2(1,0),0.2)
	emit_signal("finished")

func _process(delta):
	if Input.is_action_just_pressed("dialogue") and $Panel/Continue.visible:
		emit_signal("go_on")

func turn_on_song():
	$Song.play()
