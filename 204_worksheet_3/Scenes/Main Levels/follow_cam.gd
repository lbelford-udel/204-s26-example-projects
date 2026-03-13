extends Camera2D

@export var zoomed_in_value = 1
@export var zoomed_out_value = 0.5
@export var zoomed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if zoomed:
		zoom_in()
	else:
		zoom_out()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("zoom_camera"):
		print("zoom button")
		if zoomed:
			zoom_out()
		else:
			zoom_in()


func zoom_in():
	print("zooming in")
	zoom = Vector2(zoomed_in_value, zoomed_in_value)
	zoomed = true

func zoom_out():
	print("zooming out")
	zoom = Vector2(zoomed_out_value, zoomed_out_value)
	zoomed = false
