extends StaticBody2D

class_name Block

@export var active = true

##sets the block to the proper starting state upon being loaded in
func _ready():
	visible = active
	$CollisionShape2D.disabled = !active

##toggles block visibility and collision when block recieves signal from connected switch

func _on_switch_hit():
	visible = !visible
	call_deferred("toggleBlock")

func toggleBlock():
	$CollisionShape2D.disabled = !$CollisionShape2D.disabled
	
