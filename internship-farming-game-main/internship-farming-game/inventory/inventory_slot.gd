extends Resource

class_name InventorySlot

@export var item: InventoryItem
@export var amount: int
@export var is_active: bool = false
@export var to_be_removed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
