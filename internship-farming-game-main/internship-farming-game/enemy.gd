extends Node

var max_health: int 
var current_health: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
