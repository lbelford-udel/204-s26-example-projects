extends Area2D

#signal player_enters(Vector2)

##connects the player_enters signal to the camera's interpolation function using the CameraPoint's position as a parameter
#func _ready():
#	player_enters.connect(get_parent().get_node("Camera2D").interpolate_camera)

##detects when the player enters the area and sends out a signal
#func _on_body_entered(_body):
#	player_enters.emit($CameraPoint.global_position)
