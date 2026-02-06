extends TextureRect

var player_in = false

func _input(_event):
	if(Input.is_action_just_pressed("interact") and player_in):
		queue_free()

func on_player_enter(_body):
	visible = true
	player_in = true

func on_player_exit(_body):
	visible = false
	player_in = false
