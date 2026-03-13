extends MeshInstance2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self_modulate = random_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func random_color() -> Color:
	var random_r = randf_range(0.0,1.0)
	var random_g = randf_range(0.0,1.0)
	var random_b = randf_range(0.0,1.0)
	return Color(random_r, random_g, random_b)
