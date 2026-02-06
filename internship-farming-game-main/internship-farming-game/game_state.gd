extends Node

enum Game_State {PLAYING, TALKING, MENU}
var current_game_state = Game_State.PLAYING

enum Player_Facing_State {RIGHT, LEFT, UP, DOWN}
var current_player_state = Player_Facing_State.RIGHT

enum Season_State {SPRING, SUMMER, AUTUMN, WINTER}
var current_season_state = Season_State.SPRING

enum Day_Otw_State {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}
var current_day_otw_state = Day_Otw_State.MONDAY 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter_playing():
	current_game_state = Game_State.PLAYING

func enter_talking():
	current_game_state = Game_State.TALKING

func enter_menu():
	current_game_state = Game_State.MENU

func check_playing():
	if current_game_state == Game_State.PLAYING:
		return true
	else: 
		return false 

func check_talking():
	if current_game_state == Game_State.TALKING:
		return true 
	else: 
		return false 

func check_menu():
	if current_game_state == Game_State.MENU:
		return true 
	else: 
		return false 

func enter_right():
	current_player_state = Player_Facing_State.RIGHT

func enter_left():
	current_player_state = Player_Facing_State.LEFT

func enter_up():
	current_player_state = Player_Facing_State.UP

func enter_down():
	current_player_state = Player_Facing_State.DOWN

func change_day_otw():
	if current_day_otw_state == Day_Otw_State.SUNDAY:
		current_day_otw_state = Day_Otw_State.MONDAY
	else:
		current_day_otw_state += 1

func change_season():
	if current_season_state == Season_State.WINTER:
		current_season_state = Season_State.SPRING
	else:
		current_season_state += 1
