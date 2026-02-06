extends Control

@onready var money_label = $RichTextLabel2
var starting_money = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money_label.text = str(starting_money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_money(int):
	money_label.text = str(int)
