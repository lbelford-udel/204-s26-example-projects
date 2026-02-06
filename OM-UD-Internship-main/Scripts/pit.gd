extends Area2D

##handles how objects behave when colliding with a pit
#body: body which collides with Area2D
#body is player: sends player back to tile from where they entered
#body is enemies and objects: removes them from the scene tree
func _on_body_entered(body):
	var fallingEffect = load("res://Scenes/fallingEffect.tscn").instantiate()
	get_parent().add_child(fallingEffect)
	fallingEffect.global_position = body.global_position
	if(body is CharacterBody2D):
		await body.falling_state(body.respawn_position)
		print_debug("player fell")
		body.hurt_state(false)
	if(body is RigidBody2D):
		body.queue_free()
		await get_tree().create_timer(1.0).timeout
	fallingEffect.queue_free()
