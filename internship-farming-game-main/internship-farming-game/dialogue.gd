extends Control

# D1
signal lines_to_send(data: Array)
@export var lines_to_read = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# D1
func _on_sprite_2d_npc_clicked() -> void:
	visible = true
	#GameState.enter_talking()
	lines_to_send.emit(lines_to_read)
	


func _on_text_box_dialogue_finished() -> void:
	visible = false 
	GameState.enter_playing()
