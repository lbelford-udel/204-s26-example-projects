extends Area2D

@export var camera_zone: Area2D

signal player_enter(camera_point)

##connects player enter signal to the camera's interpolation function upon loading scene
func _ready():
	player_enter.connect(get_parent().get_node("Camera2D").interpolate_camera)

##sends player to the global Vector of Node2D upon collision
#body: body which collides with Area2D, should only be the player
func _on_body_entered(body):
	body.position = to_global($Node2D.position)
	body.respawn_position = body.position
	player_enter.emit(camera_zone.get_node("CameraPoint").global_position)
	print_debug("Player sent to" + str(to_global($Node2D.position)))
