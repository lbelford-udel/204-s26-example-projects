extends Sprite2D

signal npc_clicked

# Called when the node enters the scene tree for the first time.
# D2
# Look at dictionaries and setting arrays of arrays 
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if GameState.check_playing():
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT: 
			if get_rect().has_point(to_local(event.position)):
				npc_clicked.emit()
