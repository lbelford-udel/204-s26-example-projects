extends Control

##updates itemframe1 with sword item texture
func sword_get():
	$itemFrame1/itemIcon.texture = load("res://Assets/UI/item_icon_sword_8px1.png")

##updates itemframe2 with mirror item texture
func mirror_get():
	$itemFrame2/itemIcon.texture = load("res://Assets/UI/item_icon_mirror1.png")

##makes key texture visible in HUD
func key_get():
	$keyIcon.visible = true
