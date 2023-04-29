extends CanvasLayer

const CHAR_READ_RATE = 0.05
signal go_on
signal finished

func _ready():
	$Panel/Text.visible_ratio = 0.0
	$Panel.scale = Vector2(1,0)
	$Panel/Continue.hide()

func show_dialogue(text_array):
	get_tree().paused = true
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property($Panel,"scale",Vector2(1,1),0.2)
	await(tween.finished)
	for text in text_array:
		$Panel/Continue.hide()
		$Panel/Text.text = text
		var text_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		text_tween.tween_property($Panel/Text,"visible_ratio",1.0,len(text)*CHAR_READ_RATE)
		await(text_tween.finished)
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
