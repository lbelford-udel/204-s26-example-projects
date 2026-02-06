extends InventoryItem

class_name Seed

#C1
#Make it so the crop's growth state is tracked by the seed
#and not simply from farm tile
enum Growth_State {SEED, SPROUT, HARVESTABLE}
@export var current_growth_state = Growth_State.SEED
#C2
#Make it so crops have variable growth days and seasons
@export var days_to_grow: int 
@export var day_growing: int
@export var growable_seasons = []

@export var sell_price: int

@export var future_crop: Crop
@export var future_crop_scene: PackedScene
@export var tilled_seeded = preload("res://art/tilled-seeded-land.png")
@export var tilled_seeded_watered = preload("res://art/tilled-seeded-watered-land.png")
@export var tilled_sprouting = preload("res://art/tilled-sprouting-land.png")
@export var tilled_sprouting_watered = preload("res://art/tilled-sprouting-watered-land.png")
@export var tilled_harvestable: Texture2D
@export var tilled_harvestable_watered: Texture2D 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
