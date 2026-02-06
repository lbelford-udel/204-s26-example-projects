extends RigidBody2D

signal hit_something

var origin_point

var waiting = false

var interact_type = "carry"

##saves the throwStone's starting position in the origin_point variable
#ensures all instances of throwStone connect to the player's _on_hit_something functions
func _ready():
	origin_point = global_position
	hit_something.connect(get_parent().get_node("Player")._on_hit_something)
	get_parent().get_node("LoadZone2_3").player_enter.connect(reappear)

func _physics_process(_delta):
	move_and_collide(Vector2(0,0))

##detects hitbox collisions
#body: body on the hitbox or wall layers
func _on_area_2d_body_entered(_body):
	hit_something.emit()

##if the stone is in the wait state, it will reappear when the player reenters the room
func reappear(_filler):
	if(waiting):
		visible = true
		call_deferred("toggleCollider")
		waiting = false

##turns collider on and off
#used to avoid errors
func toggleCollider():
	get_node("CollisionShape2D").disabled = !get_node("CollisionShape2D").disabled

##creates new instance of throwStone and sends it to origin_point upon current instance being destroyed
func _on_tree_exiting():
	var new_stone = preload("res://Scenes/throwStone.tscn").instantiate()
	get_parent().add_child.call_deferred(new_stone)
	new_stone.position = origin_point
	new_stone.visible = false
	new_stone.call_deferred("toggleCollider")
	new_stone.waiting = true
