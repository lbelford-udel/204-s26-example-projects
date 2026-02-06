extends Area2D

##disappears when the player touches it
func _on_body_entered(_body):
	queue_free()
