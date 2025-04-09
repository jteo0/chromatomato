extends Node

signal tomato_pickup # pick up the tomato
signal tomato_give # give tomato to crystal
signal finish_transformation(state, form)
signal hit_tiles(tiles)
signal pause_pressed(active: bool)
signal level_done
signal hp_down(hp)
signal freeze_me(me)
signal push_me(me, dir)
signal break_me(me)

enum Forms {FORM_BLUE, FORM_RED, FORM_YELLOW, FORM_WHITE}
enum States {IDLE, RUN, JUMP, TRANSFORM, INTERACT_UP, INTERACT_RIGHT}

var current_form: Forms = Forms.FORM_WHITE
var current_state: States = States.IDLE
var chromaforce = 100

var player_tomato = 0.0
var in_transform: bool = false
var unlocked_level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
