extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/inventory_ui.initialize_active_inventory()
	$CanvasLayer2/inventory_hotbar_ui.initialize_active_inventory()
	$CanvasLayer/inventory_ui.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
