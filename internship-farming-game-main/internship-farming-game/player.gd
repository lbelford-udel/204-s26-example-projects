extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@export var inventory: Inventory

@export var max_health = 100
@export var current_health: int

@export var current_money: int
signal money_change(data: int)

func _ready() -> void:
	current_health = max_health

func _process(delta: float) -> void:
	if GameState.check_playing():
		
		if Input.is_action_just_pressed("right"):
			GameState.enter_right()
			$Sprite2D.texture = load("res://art/test-avatar-1.png")
		elif Input.is_action_just_pressed("left"):
			GameState.enter_left()
			$Sprite2D.texture = load("res://art/test-avatar-1-left.png")
		elif Input.is_action_just_pressed("up"):
			GameState.enter_up()
			$Sprite2D.texture = load("res://art/test-avatar-1-back.png")
		elif Input.is_action_just_pressed("down"):
			GameState.enter_down()
			$Sprite2D.texture = load("res://art/test-avatar-1-front.png")
	money_change.emit(current_money)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	# I don't currently want gravity
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	# I don't currently want jumping
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#if GameState.check_playing():
	var horizontal_direction := Input.get_axis("left", "right")
	if horizontal_direction and GameState.check_playing():
		velocity.x = horizontal_direction * SPEED
	elif !GameState.check_playing():
		velocity.x = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	var vertical_direction := Input.get_axis("up", "down")
	if vertical_direction and GameState.check_playing():
		velocity.y = vertical_direction * SPEED
	elif !GameState.check_playing():
		velocity.y = 0
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func collect(item):
	var was_inventory_full = inventory.insert(item)
	return was_inventory_full

func _on_inventory_ui_to_remove_slot_number(data: int) -> void:
	inventory.remove(data)


func _on_inventory_ui_money_sold(data: int) -> void:
	current_money += data
