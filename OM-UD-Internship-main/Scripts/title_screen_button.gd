extends Button

##makes sure the scene is unpaused and then goes to the title screen
func _on_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
