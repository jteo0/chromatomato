extends Node

signal tomato_pickup # pick up the tomato
signal finish_transformation(state, form) # finalize transformation
signal level_done(level_name)
signal hp_down(hp) # everytime hp goes down
signal freeze_me(me)
signal push_me(me, dir)
signal break_me(me)
signal turn_always() # transformation process = always
signal turn_pausable() # transformation process = pausable
signal repause()
signal dead()
signal has_started()
signal play_sound(to_play)

enum Forms {FORM_BLUE, FORM_RED, FORM_YELLOW, FORM_WHITE}
enum States {IDLE, RUN, JUMP, TRANSFORM, INTERACT_UP, INTERACT_RIGHT}

var current_form: Forms = Forms.FORM_WHITE
var current_state: States = States.IDLE

var player_tomato = 0.0
var in_transform: bool = false
var unlocked_level = 0
var level_playing = 0
var has_respawned = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_done.connect(unlock_levels)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func unlock_levels(level):
	var temp_level
	match level:
		"0: Beginning":
			temp_level = 1
			if temp_level > unlocked_level:
				unlocked_level = 1
		"1: Jump":
			temp_level = 2
			if temp_level > unlocked_level:
				unlocked_level = 2
		"2: Break":
			temp_level = 3
			if temp_level > unlocked_level:
				unlocked_level = 3
		"3: Tower":
			pass
