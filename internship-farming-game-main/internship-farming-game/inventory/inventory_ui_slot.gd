extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label
@onready var outline_visual: Sprite2D = $OutlineSprite2D

func update(slot: InventorySlot):
	if slot.is_active and GameState.check_playing():
		outline_visual.visible = true
	else:
		outline_visual.visible = false
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false 
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
		else: 
			amount_text.visible = false
		amount_text.text = str(slot.amount)

func deactivate(slot: InventorySlot):
	outline_visual.visible = false

# I2
# work on decreasing amount
func decrease(slot: InventorySlot):
	if slot.is_active:
		slot.amount -= 1
	if slot.amount < 1 and slot.item and slot.is_active:
		slot.to_be_removed = true
