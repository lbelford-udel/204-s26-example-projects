extends StaticBody2D

signal hit

var mirrored = false

@export var sprite = "res://Assets/switch_off1.png"

##sets the switch to the proper starting sprite
func _ready():
	$MirrorVer/Sprite2D.texture = $Sprite2D.texture
	$Sprite2D.texture = load(sprite)

##handles toggling switch sprite and emitting signals to connected nodes
#also handles MirrorVer if it's active
func _on_area_2d_area_entered(_area):
	if($Sprite2D.texture == load("res://Assets/switch_off1.png")):
		$Sprite2D.texture = load("res://Assets/switch_on1.png")
		hit.emit()
	else:
		$Sprite2D.texture = load("res://Assets/switch_off1.png")
		hit.emit()
	print_debug("switch hit")
	
	$MirrorVer/Sprite2D.texture = $Sprite2D.texture


##handles the appearance and dissapearance of MirrorVer
#toggle: boolean that determines if MirrorVer's visibility and colliders get turned on or off
#uses mirrored boolean to avoid having it run every frame
func mirrorOn(toggle):
	if(toggle):
		if(!mirrored):
			#$MirrorVer.global_position.x += 10
			$MirrorVer/CollisionShape2D.disabled = false
			$MirrorVer/Sprite2D.visible = true
			$MirrorVer/Area2D.monitorable = true
			$MirrorVer/Area2D.monitoring = true
			mirrored = true
			print_debug("Switch mirrored on")
	else:
		if(mirrored):
			$MirrorVer.position = Vector2(0,0)
			$MirrorVer/CollisionShape2D.disabled = true
			$MirrorVer/Sprite2D.visible = false
			$MirrorVer/Area2D.monitorable = false
			$MirrorVer/Area2D.monitoring = false
			mirrored = false
			print_debug("Switch mirrored off")
	
