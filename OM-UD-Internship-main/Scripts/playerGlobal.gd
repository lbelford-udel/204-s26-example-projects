extends Node

var active_directions = []

##ensures this script will always be running
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

##checks pressed and released movement keys every frame and adds or removes them from active_directions
func _physics_process(_delta):
	if Input.is_action_just_pressed("move_down"):
		active_directions.append("down")
	elif Input.is_action_just_released("move_down"):
		active_directions.erase("down")
	
	if Input.is_action_just_pressed("move_up"):
		active_directions.append("up")
	elif Input.is_action_just_released("move_up"):
		active_directions.erase("up")
	
	if Input.is_action_just_pressed("move_right"):
		active_directions.append("right")
	elif Input.is_action_just_released("move_right"):
		active_directions.erase("right")
	
	if Input.is_action_just_pressed("move_left"):
		active_directions.append("left")
	elif Input.is_action_just_released("move_left"):
		active_directions.erase("left")
