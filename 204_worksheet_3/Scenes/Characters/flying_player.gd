extends CharacterBody2D



@export var acceleration = 500.0 #acceleration in pixels/second/second
@export var max_velocity = 1000.0 #max velocity in pixels/second
@export var rotation_speed_degrees = 360.0 #in degress/second
@export var push_force = 100.0


func _physics_process(delta):
	# No Gravity, so comment out (could also just delete entirely)
	#if not is_on_floor():
		#velocity += get_gravity() * delta
		
	# slide left and right has changed to rotate left and right
	# also now comes before old jump section
	var rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	if rotation_direction:
		rotate(deg_to_rad(rotation_speed_degrees * delta * rotation_direction))

	# Jump has changed to fly in the "up" direction based on current rotation
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("jump"):
		velocity -= transform.y * acceleration * delta
	elif Input.is_action_pressed("move_down"):
		velocity += transform.y * acceleration * delta
	
	#if velocity tries to go above the max_velocity "speed limit"...
	if velocity.length() > max_velocity:
		#whatever the length was, normalize it to 1
		var norm_velocity = velocity.normalized()
		#multiply normalized velocity * max_velocity to travel at exactly the max
		velocity = norm_velocity * max_velocity
	
	move_and_slide()
	push_objects()

func push_objects():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			collider.apply_central_impulse(collision.get_normal() * -1 * push_force)
		if collider is StaticBody2D:
			velocity = Vector2(0,0)
