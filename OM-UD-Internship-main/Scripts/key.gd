extends Area2D

signal key_pickup

func _on_body_entered(body):
	body.key_stock += 1
	key_pickup.emit()
	print_debug("Picked up key")
	queue_free()
