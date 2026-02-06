extends GridContainer

# I1
# wokring on hiding active slot when main inventory is open
@onready var ui_node = $"../../../../CanvasLayer/inventory_ui"
var active_queue = 0
var min_active_inventory = 0
var max_active_inventory = 4

signal send_active_queue(data: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 
	#I1
	# tried to use groups to get the inventory_ui node specifically 
	#await get_tree().create_timer(0.05).timeout
	#ui_node = get_tree().get_first_node_in_group("InventoryUI")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# I1
	if !ui_node.is_open:
		if Input.is_action_just_pressed("inventoryRight"):
			if active_queue < max_active_inventory:
				active_queue += 1
				get_parent().get_parent().inventory.slots[active_queue - 1].is_active = false
			elif active_queue == max_active_inventory:
				active_queue = min_active_inventory
				get_parent().get_parent().inventory.slots[max_active_inventory].is_active = false
			get_parent().get_parent().inventory.slots[active_queue].is_active = true
			get_parent().get_parent().update_slots()
			send_active_queue.emit(active_queue)
			
		
	if Input.is_action_just_pressed("inventoryLeft"):
		# I1
		if !ui_node.is_open:
			if active_queue	> min_active_inventory:
				active_queue -= 1
				get_parent().get_parent().inventory.slots[active_queue + 1].is_active = false
			elif active_queue == min_active_inventory:
				active_queue = max_active_inventory
				get_parent().get_parent().inventory.slots[min_active_inventory].is_active = false
			get_parent().get_parent().inventory.slots[active_queue].is_active = true
			get_parent().get_parent().update_slots()
			send_active_queue.emit(active_queue)
