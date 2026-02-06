extends Area2D

signal mirror_pickup

##when collision with player is detected:
#enables mirror for the player
#changes texure in itemFrame2
#is removed from the tree
func _on_body_entered(body):
	body.mirror_acquired = true
	mirror_pickup.emit()
	queue_free()
