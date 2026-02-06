extends Control

##makes the player disappear and the menu appear when they die
func game_end(player):
	player.queue_free()
	visible = true

##restarts the game
func _on_play_again_button_pressed():
	get_tree().reload_current_scene()
