extends Control

var active_queue_holder
@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@export var is_open = false
# I1
# below variable breaks in any scene that isn't testing 
@onready var ui_node = $"../../CanvasLayer/inventory_ui"
var slot_number_to_be_removed: int 
signal to_remove_slot_number(data: int)

# I2
@export var is_main_inventory = false 

signal money_sold(data: int)


func _ready ():
	# I1
	# tried using gropus to get inventory_ui specifically 
	#await get_tree().create_timer(0.05).timeout
	#ui_node = get_tree().get_first_node_in_group("InventoryUI")
	inventory.update.connect(update_slots)
	update_slots()

func update_slots():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
			update_slots()
		else:
			open()
			update_slots()
		# I1
		# working on hiding active slots when main inventory is open
		# currently works but is based on pathway to inventory in testing scene
		# so it breaks in any other scene
		if ui_node.is_open:
			hide_active()
			GameState.enter_menu()
		else:
			show_active()
			GameState.enter_playing()
# I2
# working on decreasing amount
	if Input.is_action_just_pressed("drop_item"):
		if !is_main_inventory and GameState.check_playing():
			decrease_slot()
		remove_item()
		update_slots()
	
	# I4 
	# working on cycling inventory
	if Input.is_action_just_pressed("next_inventory_row"):
		if !is_main_inventory and GameState.check_playing():
			var temp_inventory = load("res://inventory/temp_inventory.tres")
			var temp_active = 0
			for i in 5:
				if inventory.slots[i].is_active == true:
					temp_active = i
					inventory.slots[i].is_active = false
			for i in 5:
				temp_inventory.slots[i] = inventory.slots[i]
			for i in 10:
				inventory.slots[i] = inventory.slots[i+5]
			for i in 5:
				inventory.slots[i+10] = temp_inventory.slots[i]
			inventory.slots[temp_active].is_active = true
			update_slots()

func open():
	visible = true
	is_open = true 


func close():
	visible = false
	is_open = false
	# I3
	#GameState.current_game_state = GameState.Game_State.MENU


func initialize_active_inventory():
	inventory.slots[0].is_active = true
	update_slots()

# I1
# working on hiding active slots when main inventory screen is open
func hide_active():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].deactivate(inventory.slots[i])

# I1
func show_active():
	for i in range(min(inventory.slots.size(), slots.size())):
		update_slots()

# I2
# work on decreasing amount
func decrease_slot():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].decrease(inventory.slots[i])

# I2
func remove_item():
	for i in range(min(inventory.slots.size(), slots.size())):
		if inventory.slots[i].to_be_removed == true:
			slot_number_to_be_removed = i
			to_remove_slot_number.emit(slot_number_to_be_removed)
			inventory.slots[i].to_be_removed = false

# I5
# Change selling function to work with more than crops and seeds 
func sell_items():
	print("started!")
	var money_to_add = 0
	if !$"../../CanvasLayer2/inventory_hotbar_ui".inventory.slots.is_empty():
		if $"../../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item:
			if $"../../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item is Crop || $"../../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item is Seed:
				if !is_main_inventory and GameState.check_playing():
					money_to_add += get_tree().get_root().get_node("testing/CanvasLayer2/inventory_hotbar_ui").inventory.slots[get_tree().get_root().get_node("testing/CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer").active_queue].item.sell_price
					decrease_slot()
					remove_item()
					update_slots()
					money_sold.emit(money_to_add)



# trying to handle scrolling equating moving the active slot
# maybe do incrementation based on delta?
"""
func _input(event):
	if event is InputEventPanGesture:
		if active_queue >0:
			if event.delta.x > 0:
				active_queue =+ 1
			else:
				active_queue =+ 1
"""


func _on_grid_container_send_active_queue(data: int) -> void:
	active_queue_holder = slots[data]
