extends RigidBody2D

class_name Mirror

var mirroredObject

var directionX = 0

var directionY = 0

var zOrderModifier = 0

var interact_type = "carry"

signal hit_something

##Connects the hit_something signal to the player script upon being loaded in
#sets the direction related variabled upon being loaded in
func _ready():
	hit_something.connect(get_parent().get_node("Player")._on_hit_something)
	set_direction()

##handles toggling of mirroredObject's copy
#makes copy active and brings it in front of the mirror when raycast touches something
#makes copy inactive when raycast stops touching it
func _physics_process(_delta):
	##TBD I'm probably going to rewrite this chunk of code because I made it and I'm struggling to read it
	if($RayRotater/RayCast2D.get_collider() != null and ($RayRotater/RayCast2D.get_collider() is not TileMap and $RayRotater/RayCast2D.get_collider().get_collision_layer() != 2)):
		if(mirroredObject != null and mirroredObject != $RayRotater/RayCast2D.get_collider()):
			disable_mirrored_object()
		mirroredObject = $RayRotater/RayCast2D.get_collider()
		mirroredObject.mirrorOn(true)
		mirroredObject.z_index = z_index + zOrderModifier
		mirroredObject.get_node("MirrorVer").global_position = Vector2(position.x + 6.5 * directionX, position.y + 6.5 * directionY)
	elif(mirroredObject != null):
		disable_mirrored_object()
	
	if(!$RayRotater/RayCast2D.enabled):
		disable_mirrored_object()
	
	move_and_collide(Vector2(0,0))

##handles setting the sprite and direction of the raycast
#mirror be set to the same direction that the player is facing
func set_direction():
	if(get_parent().get_node("Player").directionY == -1):
		
		$Sprite2D.texture = load("res://Assets/mirror_up1.png")
		$RayRotater.rotation = deg_to_rad(180)
		directionY = -1
		zOrderModifier = -2
		
	elif(get_parent().get_node("Player").directionY == 1):
		
		$Sprite2D.texture = load("res://Assets/mirror_down1.png")
		$RayRotater.rotation = deg_to_rad(0)
		directionY = 1
		zOrderModifier = 1
		
	elif(get_parent().get_node("Player").directionX == -1):
		
		$Sprite2D.texture = load("res://Assets/mirror_side1.png")
		$RayRotater.rotation = deg_to_rad(90)
		directionX = -1
		zOrderModifier = 0
		
	elif(get_parent().get_node("Player").directionX == 1):
		
		$Sprite2D.texture = load("res://Assets/mirror_side1.png")
		$Sprite2D.flip_h = true
		$RayRotater.rotation = deg_to_rad(270)
		directionX = 1
		zOrderModifier = 0

##detects hitbox collisions
#body: body on the hitbox or wall layers
func _on_area_2d_body_entered(_body):
	hit_something.emit()

##destructor and helper function that handles when mirroredObject is no longer being looked at
#disables mirror version and returns it to the position of the original
func disable_mirrored_object():
	if(mirroredObject != null):
		mirroredObject.get_node("MirrorVer").global_position = Vector2(0,0)
		mirroredObject.mirrorOn(false)
