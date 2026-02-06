extends Control

var current_state_pause = state_pause.play

enum state_pause{
	pause,
	play
}

##switches the game to either paused or unpaused when the paused button is pressed
func _input(_event):
	if(Input.is_action_just_pressed("pause")):
		if(current_state_pause == state_pause.play):
			pause()
		else:
			unpause()

##pauses the game
func pause():
	current_state_pause = state_pause.pause
	visible = true
	get_tree().paused = true

##unpauses the game
func unpause():
	current_state_pause = state_pause.play
	visible = false
	get_tree().paused = false

##unpauses the game
func _on_resume_button_pressed():
	unpause()
