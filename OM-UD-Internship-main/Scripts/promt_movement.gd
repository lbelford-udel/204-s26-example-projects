extends TextureRect

##remains onscreen until player presses any movement key, then disappears
func _input(_event):
	if(Input.is_action_just_pressed("move_down") or
	Input.is_action_just_pressed("move_up") or
	Input.is_action_just_pressed("move_right") or
	Input.is_action_just_pressed("move_left")):
		await get_tree().create_timer(0.5).timeout
		queue_free()
