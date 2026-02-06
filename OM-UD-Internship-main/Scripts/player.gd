extends CharacterBody2D


##player stats
@export var healthCurrent = 8

@export var healthMax = 8

@export var healthMin = 0

##used in player movement
@export var SPEED = 30.0

@export var movement_vector = Vector2(0,0)

var directionX = 0

var directionY = -1

var currentPath

##used in respawning

var respawn_position

var respawn_pos_counter = 0.0

var respawn_pos_time = 1.0

##used in sword state machine
@export var current_state_sword = state_sword.sheath

var atkTime = 0.05

var swordStart = 0

var swordEnd = 0

##used in player state machine
var current_state_player

@export var canMove = true

@export var canAttack = true

signal player_died

##used in interacting with objects
var targetObject

var wall_detected = false

var carriedObject

var hitSomething = false

var reachedHitbox = false

var key_stock = 0

##used for player items

var sword_acquired = false

var mirror_acquired = false

var currentMirror

var being_mirrored = false


##Makes sure that the player is set to the neurtral state when loaded in
func _ready():
	neutral_state()
	rotate_player_children(0,-1,90,90,$Path2DVerti/PathFollow2D,0)
	respawn_position = position

func _physics_process(delta):
	##handles player movement
	if canMove:
		if Input.is_action_pressed("move_left"):
			movement_vector += Vector2(-1,0)
		
		if Input.is_action_pressed("move_right"):
			movement_vector += Vector2(1,0)
		
		if Input.is_action_pressed("move_up"):
			movement_vector += Vector2(0,-1)
		
		if Input.is_action_pressed("move_down"):
			movement_vector += Vector2(0,1)
		
		if(!Input.is_action_pressed("move_down") and
		!Input.is_action_pressed("move_up") and
		!Input.is_action_pressed("move_right") and
		!Input.is_action_pressed("move_left")):
			PlayerGlobal.active_directions.clear()
			if(directionX == -1):
				$AnimatedSprite2D.play("idle_left")
			elif(directionX == 1):
				$AnimatedSprite2D.play("idle_right")
			elif(directionY == -1):
				$AnimatedSprite2D.play("idle_up")
			elif(directionY == 1):
				$AnimatedSprite2D.play("idle_down")
		else:
			if(PlayerGlobal.active_directions):
				set_player_direction()
		
		respawn_pos_counter += delta
		if(respawn_pos_counter/respawn_pos_time >= 1):
			respawn_position = position
			respawn_pos_counter = 0
	
	
	#responsible for making sure the object stored in the carriedObject variable is carried by the player
	#does not run if the player is not currently carrying anything
	if(carriedObject != null):
		
		#if statement passes when carriedObject is thrown horizontally and collides with a body
		#thrown object will continue following only the y position of the pathFollow, and land in front of the player
		if(hitSomething):
			if(currentPath == $Path2D/PathFollow2D):
				carriedObject.position.y = currentPath.global_position.y
		else:
			carriedObject.position = currentPath.global_position
		
		#handles the position of carriedObject's hitbox
		#hitbox follows player's y position and carriedObject's x position when throwing left or right
		#when throwing up or down, hitbox will follow player's y position until carriedObject is on the same y as its hitbox, then will follow carriedObject
		#carriedObject should collide with things the player is facing when thrown
		if(current_state_player == state_player.throw):
			if(!hitSomething):
				carriedObject.get_node("Area2D").global_position.x = currentPath.global_position.x
			
			if(reachedHitbox or directionY == -1):
				carriedObject.get_node("Area2D").position.y = 0
			else:
				carriedObject.get_node("Area2D").global_position.y = position.y
				
			if(carriedObject.get_node("Area2D").position.y <= 0):
				reachedHitbox = true
			
		else:
			carriedObject.get_node("Area2D").global_position = position
	
	update_mirrorVer()
	
	position += movement_vector.normalized() * SPEED * delta
	
	move_and_collide(Vector2(0,0))
	
	movement_vector = Vector2(0,0)

##handles rotation of the player's children and direction tracking
#dirX: 1 for right, -1 for left, 0 for up or down
#dirY: -1 for up, 1 for down, 0 for right or left
#srdDeg: Rotation (in degrees) of player's sword
#detDeg: Rotation (in degrees) of player's detector area
#path: PathFollow2D that a thrown object will follow
#srdZI: 2 for sword appearing on top of player sprite, 0 for below
func rotate_player_children(dirX, dirY, srdDeg, detDeg, path, srdZI):
	directionX = dirX
	directionY = dirY
			
	$Sword.rotation = deg_to_rad(srdDeg)
	$DetectorCenter.rotation = deg_to_rad(detDeg)
	
	$Sword.z_index = srdZI
			
	currentPath = path

##makes the player face the direction in the first index of the active_directions array
func set_player_direction():
	match PlayerGlobal.active_directions.front():
		"left":
			rotate_player_children(-1,0,0,0,$Path2D/PathFollow2D,0)
			
			#flips the horizontal throwing path to face left
			$Path2D.scale.x = -1
			
			$AnimatedSprite2D.play("walk_left")
		"right":
			rotate_player_children(1,0,180,180,$Path2D/PathFollow2D,0)
			
			#flips the horizontal throwing path to face right
			$Path2D.scale.x = 1
			
			$AnimatedSprite2D.play("walk_right")
		"up":
			rotate_player_children(0,-1,90,90,$Path2DVerti/PathFollow2D,0)
			
			#flips the vertical throwing path to point upwards
			$Path2DVerti.curve.set_point_position(1,Vector2(0,-357))
			
			$AnimatedSprite2D.play("walk_up")
		"down":
			rotate_player_children(0,1,270,270,$Path2DVerti/PathFollow2D,2)
			
			#flips the vertical throwing path to point downwards
			#this causes it to be longer because the endpoint's position is relative to the player, and the path starts above the player
			$Path2DVerti.curve.set_point_position(1,Vector2(0,357))
			
			$AnimatedSprite2D.play("walk_down")

##if a thrown carriedObject collides with a body on its mask layer, hitSomething is set to true
#hitSomething: handles movement of carriedObject after collision
func _on_hit_something():
	hitSomething = true
	#print_debug("hit something")

#func drop_object():
#	var start = carriedObject.position
#	var end = start + Vector2(0,1)
#	var timePassed = 0
#	while timePassed < 1:
#		carriedObject.position = start.lerp(end, timePassed/0.15)
#		timePassed += get_process_delta_time()
#		await get_tree().process_frame
#	await get_tree().process_frame
#	carriedObject.get_node("CollisionShape2D").disabled = false
#	carriedObject.get_node("Area2D/Hitbox").disabled = true
#	carriedObject = null

##Makes sure the sprite and sword properties of player's mirror version match the player's if being mirrored
func update_mirrorVer():
	if(being_mirrored):
		$MirrorVer/AnimatedSprite2D.play($AnimatedSprite2D.animation)
		
		$MirrorVer/Sword/Sprite2D.visible = $Sword/Sprite2D.visible
		
		$MirrorVer/Sword.rotation = $Sword.rotation
		
		$MirrorVer/Sword.z_index = $Sword.z_index
		
		$MirrorVer/Sword.position = $Sword.position
		
		$MirrorVer/Sword/CollisionShape2D.disabled = $Sword/CollisionShape2D.disabled

##turns on the player's mirror version and the update_mirrorVer function
func mirrorOn(toggle):
	being_mirrored = toggle
	$MirrorVer.visible = toggle
	$MirrorVer/CollisionShape2D.disabled = !toggle

func _input(_event):
	##handles the player's sword attack
	if Input.is_action_just_pressed("attack") and canAttack and sword_acquired:
		attack_state()
		
		sword_toggle(true)
		
		#sets the Vectors for the sword to interpolate between
		#swordEnd is one tile's length ahead of swordStart, multiplied by 1, 0, or -1 for direction
		swordStart = $Sword.position
		swordEnd = swordStart + Vector2(136 * directionX ,92 * directionY)
		
		current_state_sword = state_sword.stab
		await interpolate_sword(swordStart, swordEnd)
		
		#ensures that the sword ends on the player position after interpolation
		$Sword.position = swordStart
		
		sword_toggle(false)
		
		neutral_state()
		
		##handled sword interpolation, replaced by interpolate_sword()
		#kept for debugging of interpolate_sword()
		#
		#timePassed = 0
		#while timePassed < atkTime:
		#	$Sword.position = swordStart.lerp(swordEnd, timePassed/atkTime)
		#	timePassed += get_process_delta_time()
		#	await get_tree().process_frame
		#resets timePassed and then brings the sword back to its original position
		#interpolate_sword(swordEnd, swordStart)
		#timePassed = 0
		#while timePassed < atkTime:
		#	$Sword.position = swordEnd.lerp(swordStart, timePassed/atkTime)
		#	timePassed += get_process_delta_time()
		#	await get_tree().process_frame
	
	
	##handles what occurs when the interact button is pressed
	if(Input.is_action_just_pressed("interact")):
		##handles whether the player interacts with the object in front of them or throws their carried object
		#if the player is facing an interactable and is in the neutral state, an interaction will occur
		#if the player is in the carry state, they will throw the currently carried object
		if(targetObject != null and current_state_player == state_player.neutral):
			##handles what kind of interaction occurs depending on the targetObject's interact type variable
			match targetObject.interact_type:
				"carry":
					await interact_state()
					pickup(targetObject)
				"unlock":
					if(key_stock > 0):
						interact_state()
						key_stock -= 1
						if(key_stock == 0):
							$"../Camera2D/UI/HUD/keyIcon".visible = false
						targetObject.queue_free()
						print_debug("Door unlocked")
		elif current_state_player == state_player.carry:
			throw_state()
			while currentPath.progress_ratio < 1:
				currentPath.progress_ratio += 4 * get_process_delta_time()
				await get_tree().process_frame
				
			##unfinished function for interpolating objects out of what they are overlapping with
			#should make carriedObject interpolate out of anything it is inside of
			if carriedObject.get_node("Area2D").has_overlapping_bodies():
				await wall_throw_handler()
			
			#resets used variables, puts the player in the neutral state, releases carriedObject from player
			hitSomething = false
			print_debug("hitSomething reset")
			reachedHitbox = false
			currentPath.progress_ratio = 0
			neutral_state()
			carriedObject = null
	
	
	##handles when mirror item is used
	#instantiates new mirror scene, adds it to the scene tree, and positions it in front of where the player is facing
	#checks if a mirror is already placed, and if so removes current mirror before instatiating new mirror
	if Input.is_action_just_pressed("use_item"):
		if(mirror_acquired and current_state_player == state_player.neutral and !wall_detected):
			if currentMirror != null:
				currentMirror.queue_free()
			currentMirror = load("res://Scenes/mirror.tscn").instantiate()
			get_parent().add_child.call_deferred(currentMirror)
			currentMirror.global_position = Vector2(position.x + 10 * directionX, position.y + 10 * directionY)

func wall_throw_handler():
	carriedObject.get_node("PlayerPusher").monitoring = true
	while carriedObject.get_node("Area2D").has_overlapping_bodies():
		carriedObject.position -= Vector2(40 * directionX, 40 * directionY) * get_process_delta_time()
		if(carriedObject.get_node("PlayerPusher").has_overlapping_bodies()):
			position -= Vector2(40 * directionX, 40 * directionY) * get_process_delta_time()
		await get_tree().process_frame
	
	carriedObject.get_node("PlayerPusher").monitoring = false

##handles sword interpolation
#startPos: Vector the sword interpolates from
#endPos: Vector the sword interpolates too
func interpolate_sword(startPos, endPos):
	var timePassed = 0
	#handles interpolation from startPos to endPos at atkTime speed
	while timePassed < atkTime:
		$Sword.position = startPos.lerp(endPos, timePassed/atkTime)
		timePassed += get_process_delta_time()
		await get_tree().process_frame
	if(current_state_sword == state_sword.stab):
		await get_tree().create_timer(0.2).timeout
	#ensures sword will interpolate to endPos, then to startPos, then reset to sheath state
	if current_state_sword == state_sword.stab:
		current_state_sword = state_sword.retract
		await interpolate_sword(endPos,startPos)
	elif current_state_sword == state_sword.retract:
		current_state_sword = state_sword.sheath

##handles the collision and visibility of player's sword
#toggle: true to enable, false to disable
func sword_toggle(toggle):
	$Sword/CollisionShape2D.disabled = !toggle
	$Sword/Sprite2D.visible = toggle

##when sword hits a body that is only on the wall layer, is disables its hitbox for the rest of the attack
func sword_blocked(body):
	if(body is TileMap or body is Block):
		call_deferred("deffer_srd_hitbox")
#used for call_deffered in sword_blocked
func deffer_srd_hitbox():
	$Sword/CollisionShape2D.disabled = true

##handles player state transition to carrying
#object: interactable the player will be carrying
func pickup(object):
	carriedObject = object
	carry_state()

##targetObject holds whatever body on the interables layer the player's detector is currently touching
func _on_detector_body_entered(body):
	targetObject = body
	$InteractPrompt.visible = true
	match targetObject.interact_type:
		"carry":
			$InteractPrompt/ActionPrompt.texture = load("res://Assets/UI/prompt_pickup1.png")
		"unlock":
			$InteractPrompt/ActionPrompt.texture = load("res://Assets/UI/prompt_open1.png")
		_:
			$InteractPrompt/ActionPrompt.texture = null
##targetObject should be empty when the player's detector is not colliding
func _on_detector_body_exited(_body):
	targetObject = null
	$InteractPrompt.visible = false

##when WallDetector sees a body on the wall layer, sets wall_detected to true
func on_wall_detector_entered(_body):
	wall_detected = true
##when WallDetector leaves a body on the wall layer, sets wall_detected to false
func on_wall_detector_exited(_body):
	wall_detected = false

##State machine for the player
enum state_player{
	neutral,
	attack,
	carry,
	throw,
	hurt,
	dead,
	falling,
	interact
}

##neutral: player can move, attack, and interact
#entered from: attack, throw, hurt
#enters into: attack, carry, hurt
func neutral_state():
	current_state_player = state_player.neutral
	canAttack = true
	canMove = true
	
	#state variables for carriedObject
	#carriedObject's collision box should be enabled and its hitbox disabled
	if(carriedObject != null):
		carriedObject.get_node("CollisionShape2D").disabled = false
		carriedObject.get_node("Area2D/Hitbox").disabled = true
		if(carriedObject is Mirror):
			carriedObject.get_node("RayRotater/RayCast2D").enabled = true

##attack: player cannot move or attack
#entered from: neutral
#enters into: neutral, hurt
func attack_state():
	current_state_player = state_player.attack
	canMove = false
	canAttack = false
	
	if(directionX == -1):
		$AnimatedSprite2D.animation = "attack_left"
	elif(directionX == 1):
		$AnimatedSprite2D.animation = "attack_right"
	elif(directionY == -1):
			$AnimatedSprite2D.animation = "attack_up"
	elif(directionY == 1):
		$AnimatedSprite2D.animation = "attack_down"

##carry: player can move and cannot attack
#entered from: neutral
#enters into: throw, hurt
func carry_state():
	current_state_player = state_player.carry
	canMove = true
	canAttack = false
	
	#state variables for carriedObject
	#neither of carriedObjects colliders should be enabled
	carriedObject.get_node("CollisionShape2D").disabled = true
	if(carriedObject is Mirror):
		carriedObject.get_node("RayRotater/RayCast2D").enabled = false

##throw: player cannot move or attack
#entered from: carry
#enters into: neutral, hurt
func throw_state():
	current_state_player = state_player.throw
	canMove = false
	canAttack = false
	
	#state variables for carriedObject
	#carriedObject's hitbox should be enabled and collider disabled
	carriedObject.get_node("Area2D/Hitbox").disabled = false

##hurt: player cannot move or attack, hurt animation will play, reduce healthCurrent by 1 and update the healthbar
#knockback: bool, true - player will be pushed back when damaged, false - player will not be pushed back
#entered from: neutral, attack, carry, throw, dead
#enters into: neutral, dead
func hurt_state(knockback):
	#var previous_state = current_state_player
	current_state_player = state_player.hurt
	
	healthCurrent -= 1
	get_node("../Camera2D/UI/HUD/healthBar").value = healthCurrent
	
	canMove = false
	canAttack = false
	
	#if(carriedObject != null):
		#drop_object()
	
	if(directionX == -1):
		$AnimatedSprite2D.play("hurt_left")
	elif(directionX == 1):
		$AnimatedSprite2D.play("hurt_right")
	elif(directionY == -1):
		$AnimatedSprite2D.play("hurt_up")
	elif(directionY == 1):
		$AnimatedSprite2D.play("hurt_down")
	
	if(knockback):
		var start = position
		var end = Vector2(position.x - 10 * directionX, position.y - 10 * directionY)
		var progress = 0.0
		while(progress < 0.1):
			position = start.lerp(end, progress/0.1)
			progress += get_process_delta_time()
			await get_tree().process_frame
	
	await get_tree().create_timer(1.0).timeout
	
	if(healthCurrent <= healthMin):
		dead_state()
	else:
		neutral_state()
		carriedObject = null

##dead: player cannot move or attack, death animation will play
#entered from: hurt
#enters into: none
func dead_state():
	current_state_player = state_player.dead
	visible = false
	player_died.emit(self)
	print_debug("player died")
	

##falling: player cannot move or attack, player disappears for 1 second before reappearing somewhere else decided by reappearPlace parameter
#returnPlace: Vector added to player's current position, decided where they reappear
#entered from: neutral, carrying
#enters into: hurt
func falling_state(reappearPlace):
	current_state_player = state_player.falling
	
	canMove = false
	canAttack = false
	
	position = reappearPlace
	
	call_deferred("togglePlayerCollider")
	$"AnimatedSprite2D".visible = false
	await get_tree().create_timer(1.0).timeout
	call_deferred("togglePlayerCollider")
	$"AnimatedSprite2D".visible = true

##stops the player's movement and puts the player into a swordless attack animation for a short time
#entered from: neutral
#enters into: neutral
func interact_state():
	current_state_player = state_player.interact
	
	canMove = false
	canAttack = false
	
	if(directionX == -1):
		$AnimatedSprite2D.animation = "attack_left"
	elif(directionX == 1):
		$AnimatedSprite2D.animation = "attack_right"
	elif(directionY == -1):
			$AnimatedSprite2D.animation = "attack_up"
	elif(directionY == 1):
		$AnimatedSprite2D.animation = "attack_down"
	
	await get_tree().create_timer(0.3).timeout
	neutral_state()

##toggles the player's collisionshape on and off
#used with call_deferred to avoid errors
func togglePlayerCollider():
	$CollisionShape2D.disabled = !$CollisionShape2D.disabled

##State machine for the sword
enum state_sword{
	sheath,
	stab,
	retract
}
