extends Control

@export var next_scene:String

func goto_next_scene():
	get_tree().change_scene_to_file(next_scene)

func reload_cur_scene():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()


func show_ui():
	show()
