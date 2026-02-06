extends Area2D

enum Farm_Tile_State 
{UNTILLED, TILLED, TILLED_WATERED, 
TILLED_SEEDED, TILLED_SEEDED_WATERED, TILLED_SPROUTING, 
TILLED_SPROUTING_WATERED, TILLED_HARVESTABLE, 
TILLED_HARVESTABLE_WATERED, WATERED}
var current_farm_tile_state = Farm_Tile_State.UNTILLED
@onready var tile_texture = $Sprite2D
@export var tile_inventory: Inventory 
@export var planted_crop: Seed
var player = SceneMultiplayer
var is_player_inside = false


func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player":
		is_player_inside = true
		player = body

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	if body.name == "player":
		is_player_inside = false


func _input(event):
	
	# when player clicks on farm tile and is nearby
	# and has a hoe selected as an active item, then
	# turn farm tile into tilled texture 
	if event is InputEventMouseButton and event.pressed and is_player_inside:
		var tex = $CollisionShape2D.shape
		if tex == null:
			return
		
		var sprite_size = tex.get_size() * scale
		var top_left = global_position - sprite_size / 2.0
		var mouse_pos = get_global_mouse_position()
		var sprite_rect = Rect2(top_left, sprite_size)
		
		if sprite_rect.has_point(mouse_pos):
			if current_farm_tile_state == Farm_Tile_State.TILLED_HARVESTABLE || current_farm_tile_state == Farm_Tile_State.TILLED_HARVESTABLE_WATERED:
				var harvest = tile_inventory.slots[0].item.future_crop_scene
				var harvest_instance = harvest.instantiate()
				add_child(harvest_instance)
				enter_untilled()
				tile_inventory.slots[0].item = null
			elif is_hoe_active():
				if current_farm_tile_state == Farm_Tile_State.UNTILLED:
					enter_tilled()
				elif current_farm_tile_state == Farm_Tile_State.WATERED:
					enter_tilled_watered()
				else:
					pass
			elif is_watering_can_active():
				if current_farm_tile_state == Farm_Tile_State.UNTILLED:
					enter_watered()
				elif current_farm_tile_state == Farm_Tile_State.TILLED:
					enter_tilled_watered()
				elif current_farm_tile_state == Farm_Tile_State.TILLED_SEEDED:
					enter_tilled_seeded_watered()
				elif current_farm_tile_state == Farm_Tile_State.TILLED_SPROUTING:
					enter_tilled_sprouting_watered()
				elif current_farm_tile_state == Farm_Tile_State.TILLED_HARVESTABLE:
					enter_tilled_harvestable_watered()
				else:
					pass
			elif is_seeds_active():
				if current_farm_tile_state == Farm_Tile_State.TILLED:
					tile_inventory.insert($"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item)
					enter_tilled_seeded()
					Input.action_press("drop_item")
					Input.action_release("drop_item")
				elif current_farm_tile_state == Farm_Tile_State.TILLED_WATERED:
					tile_inventory.insert($"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item)
					enter_tilled_seeded_watered()
					Input.action_press("drop_item")
					Input.action_release("drop_item")

func _on_time_check_growth() -> void:
	if current_farm_tile_state == Farm_Tile_State.TILLED || current_farm_tile_state == Farm_Tile_State.TILLED_WATERED || current_farm_tile_state == Farm_Tile_State.WATERED:
		enter_untilled()
	elif current_farm_tile_state == Farm_Tile_State.TILLED_SEEDED_WATERED:
		enter_tilled_sprouting()
	elif current_farm_tile_state == Farm_Tile_State.TILLED_SPROUTING_WATERED:
		enter_tilled_harvestable()
	else:
		pass

# checks if array is empty
# as well as if item is empty
# NOTE: change final line if hoe is no longer the Item name
func is_hoe_active():
	if !$"../CanvasLayer2/inventory_hotbar_ui".inventory.slots.is_empty():
		if $"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item:
			if $"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item.name == "Hoe" || $"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item.name == "Hoe 2":
				return true
	else:
		return false

func is_watering_can_active():
	if !$"../CanvasLayer2/inventory_hotbar_ui".inventory.slots.is_empty():
		if $"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item:
			if $"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item.name == "Watering Can":
				return true
	else:
		return false

func is_seeds_active():
	if !$"../CanvasLayer2/inventory_hotbar_ui".inventory.slots.is_empty():
		if $"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item:
			if $"../CanvasLayer2/inventory_hotbar_ui".inventory.slots[$"../CanvasLayer2/inventory_hotbar_ui/NinePatchRect/GridContainer".active_queue].item is Seed:
				return true
	else:
		return false


func enter_untilled():
	current_farm_tile_state = Farm_Tile_State.UNTILLED
	tile_texture.texture = preload("res://art/untilled-land.png")

func enter_tilled():
	current_farm_tile_state = Farm_Tile_State.TILLED
	tile_texture.texture = preload("res://art/tilled-land.png")

func enter_tilled_watered():
	current_farm_tile_state = Farm_Tile_State.TILLED_WATERED
	tile_texture.texture = preload("res://art/tilled-watered-land.png")

func enter_tilled_seeded():
	current_farm_tile_state = Farm_Tile_State.TILLED_SEEDED
	tile_texture.texture = tile_inventory.slots[0].item.tilled_seeded
	#tile_texture.texture = preload("res://art/tilled-seeded-land.png")

func enter_tilled_seeded_watered():
	current_farm_tile_state = Farm_Tile_State.TILLED_SEEDED_WATERED
	tile_texture.texture = tile_inventory.slots[0].item.tilled_seeded_watered
	#tile_texture.texture = preload("res://art/tilled-seeded-watered-land.png")

func enter_tilled_sprouting():
	current_farm_tile_state = Farm_Tile_State.TILLED_SPROUTING
	tile_texture.texture = tile_inventory.slots[0].item.tilled_sprouting
	#tile_texture.texture = preload("res://art/tilled-sprouting-land.png")

func enter_tilled_sprouting_watered():
	current_farm_tile_state = Farm_Tile_State.TILLED_SPROUTING_WATERED
	tile_texture.texture = tile_inventory.slots[0].item.tilled_sprouting_watered
	#tile_texture.texture = preload("res://art/tilled-sprouting-watered-land.png")
	
func enter_tilled_harvestable():
	current_farm_tile_state = Farm_Tile_State.TILLED_HARVESTABLE
	tile_texture.texture = tile_inventory.slots[0].item.tilled_harvestable
	#tile_texture.texture = preload("res://art/tilled-harvestable-parsnip-land.png")
	
func enter_tilled_harvestable_watered():
	current_farm_tile_state = Farm_Tile_State.TILLED_HARVESTABLE_WATERED
	tile_texture.texture = tile_inventory.slots[0].item.tilled_harvestable_watered
	#tile_texture.texture = preload("res://art/tilled-harvestable-parsnip-watered-land.png")

func enter_watered():
	current_farm_tile_state = Farm_Tile_State.WATERED
	tile_texture.texture = preload("res://art/watered-land.png")



#experimenting with making farm tile harvestable
"""
func make_harvestable():
	var harvest_instance = hoe.instantiate()
	harvest_instance.rotation = rotation
	harvest_instance.global_position = $farm_tile.global_position
	get_parent().add_child(harvest_instance)
	player.collect(item)
	

func _on_make_harvestable_pressed() -> void:
	make_harvestable()
"""
