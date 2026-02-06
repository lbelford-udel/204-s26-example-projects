extends Area2D

signal sword_pickup

##when collision with player is detected:
#enables sword for the player
#changes texure in itemFrame1
#is removed from the tree
func _on_body_entered(body):
	body.sword_acquired = true
	sword_pickup.emit()
	queue_free()
