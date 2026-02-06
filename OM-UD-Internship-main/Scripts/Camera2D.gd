extends Camera2D

var startPos = position

var time = 0.5

var timePassed

##handles interpolation of camera
#end: the Vector the camera interpolates too
func interpolate_camera(end):
	get_tree().paused = true
	startPos = position
	timePassed = 0
	while timePassed <= time:
		position = startPos.lerp(end, timePassed/time)
		timePassed += get_process_delta_time()
		await get_tree().process_frame
	position = end
	get_tree().paused = false
