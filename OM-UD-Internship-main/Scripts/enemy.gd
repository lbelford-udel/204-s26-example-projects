extends CharacterBody2D

var health = 2

var start_position: Vector2
@export var start_direction: String

var movement_speed: float = 15.0
var movement_target_position: Vector2

var direction: String

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var current_state_enemy = state_enemy.idle

##state machine for enemy
enum state_enemy{
	idle,
	alert,
	chasing,
	returning,
	hurt
}


func _ready():
	start_position = global_position
	direction = start_direction
	match start_direction:
		"up":
			$AnimatedSprite2D.play("idle_up")
		"down":
			$AnimatedSprite2D.play("idle_down")
		"left":
			$AnimatedSprite2D.play("idle_side")
		"right":
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.scale.x = -1


func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		if(current_state_enemy == state_enemy.returning):
			state_idle()
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var next_path_direction: Vector2 = current_agent_position.direction_to(next_path_position)
	
	##uses next_path_position to determine enemy's movement direction
	#sets enemy's animation and direction variable to whatever direction they are walking towards
	if(current_state_enemy == state_enemy.chasing or current_state_enemy == state_enemy.returning):
		if(abs(next_path_direction.x) < abs(next_path_direction.y)):
			if(next_path_direction.y > 0):
				direction = "down"
				$AnimatedSprite2D.play("active_down")
			else:
				direction = "up"
				$AnimatedSprite2D.play("active_up")
		elif(abs(next_path_direction.x) > abs(next_path_direction.y)):
			$AnimatedSprite2D.play("active_side")
			if(next_path_direction.x > 0):
				direction = "right"
				$AnimatedSprite2D.scale.x = -1
			else:
				direction = "left"
				$AnimatedSprite2D.scale.x = 1

	if(current_state_enemy != state_enemy.hurt):
		velocity = next_path_direction * movement_speed
	move_and_slide()


##every 0.1 seconds the enemy's navigation target will update to the target's current global position
func _on_timer_timeout():
	if(current_state_enemy == state_enemy.chasing):
		movement_target_position = $"../Player".global_position
		set_movement_target(movement_target_position)

##sets navigation target
#movement_target: Vector2 which the enemy should move to
func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target


##target takes damage upon touching the enemy's hitbox
#target: Body2D on the player layer that the enemy collides with
#target won't take damage if already in hurt state
func _on_body_entered(target):
	if(target.current_state_player != target.state_player.hurt):
		target.hurt_state(true)


##enemy takes damage upon collision with a hitbox
#hitbox: Area2D on the hitbox layer that collides with enemy
#enemy won't take damage if already in the hurt state
func on_hitbox_collision(_hitbox):
	if(current_state_enemy != state_enemy.hurt):
		state_hurt()

##functions for enemy state machine

##enemy stops moving and enters their idle animation
#entered from: returning
#enters into: chasing, hurt
func state_idle():
	current_state_enemy = state_enemy.idle
	match start_direction:
		"up":
			$AnimatedSprite2D.play("idle_up")
		"down":
			$AnimatedSprite2D.play("idle_down")
		"left":
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.scale.x = 1
		"right":
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.scale.x = -1
	$AggroZone/CollisionShape2D.shape.radius = 40
	velocity = Vector2.ZERO


##changes the enemy's animation for a second before navigation begins
#target: Body2D on the player layer that represents enemy's pathfinding target
#entered from: idle
#enters into: idle, chasing, returning, hurt
func state_alert(_target):
	current_state_enemy = state_enemy.alert
	match start_direction:
		"up":
			$AnimatedSprite2D.play("alert_up")
		"down":
			$AnimatedSprite2D.play("alert_down")
		"left":
			$AnimatedSprite2D.play("alert_side")
			$AnimatedSprite2D.scale.x = 1
		"right":
			$AnimatedSprite2D.play("alert_side")
			$AnimatedSprite2D.scale.x = -1
	$AggroZone/CollisionShape2D.shape.radius = 70
	await get_tree().create_timer(0.5).timeout
	if(current_state_enemy != state_enemy.hurt):
		state_chasing()

##makes the enemy go into the chasing state when the player is comes to a certain distance from them
#target: Body2D on the player layer that represents enemy's pathfinding target
#entered from: alert, hurt
#enters into: returning, hurt
func state_chasing():
	#print_debug("Enemy Aggroed")
	current_state_enemy = state_enemy.chasing
	navigation_agent.target_desired_distance = 4.0
	$AggroZone/CollisionShape2D.shape.radius = 70


##when the target leaves the enemy's aggro zone they will pathfind back to their starting position
#once enemy's starting position has been reached they will enter the idle state
#target: Body2D on the player layer that represents enemy's pathfinding target
#entered from: chasing
#enters into: idle, hurt
func state_returning(_target):
	current_state_enemy = state_enemy.returning
	navigation_agent.target_desired_distance = 0.1
	set_movement_target(start_position)
	$AggroZone/CollisionShape2D.shape.radius = 40


##enemy takes damage when their collider is touched by a hitbox
#if this takes their health to zero, the enemy dies
#hitbox: Area2D on the hitbox layer that collides with enemy
#entered from: idle, chasing, returning
#enters into: chasing
func state_hurt():
	current_state_enemy = state_enemy.hurt
	health -= 1
	if(health <= 0):
		#print_debug("Enemy Died")
		queue_free()
	else:
		velocity = Vector2.ZERO
		match direction:
			"up":
				$AnimatedSprite2D.play("hurt_up")
			"down":
				$AnimatedSprite2D.play("hurt_down")
			"left":
				$AnimatedSprite2D.play("hurt_side")
			"right":
				$AnimatedSprite2D.play("hurt_side")
		await get_tree().create_timer(0.5).timeout
		state_chasing()

##resets the enemy back to their starting position and state
func reset(_player):
	position = start_position
	direction = start_direction
	state_idle()

##Commented out because it is unused but might be used later
#func actor_setup():
#	# Wait for the first physics frame so the NavigationServer can sync.
#	#await get_tree().physics_frame
#
#	# Now that the navigation map is no longer empty, set the movement target.
#	#set_movement_target(movement_target_position)
