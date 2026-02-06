extends StaticBody2D

@export var item: InventoryItem
var player = null

func _on_interactable_area_body_entered(body):
	if body.name == "player":
		player = body
		var was_inventory_full = playercollect()
		await get_tree().create_timer(0.1).timeout
		if !was_inventory_full: 
			self.queue_free()

func playercollect():
	var was_inventory_full = player.collect(item)
	return was_inventory_full
