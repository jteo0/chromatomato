extends Control

@export var transform_cost = 5

@onready var color_indicator = $CanvasLayer/ColorPick
@onready var overlay = $CanvasLayer

var color_pointer = 0

var form_color = 0

func _ready() -> void:
	SignalBus.turn_pausable.connect(if_paused)
	SignalBus.turn_always.connect(not_paused)
	SignalBus.repause.connect(pause_again)
	overlay.visible = false
	color_switch(color_pointer)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		if color_pointer != 0:
			color_pointer -= 1
		else:
			color_pointer = 3
		
		color_switch(color_pointer)
		
	if Input.is_action_just_pressed("move_right"):
		if color_pointer != 3:
			color_pointer += 1
		else:
			color_pointer = 0
			
		color_switch(color_pointer)
		
	if Input.is_action_just_pressed("transform"):
		if !SignalBus.in_transform:
			SignalBus.hp_down.emit(transform_cost)
			SignalBus.play_sound.emit("transform_start.mp3")
			transformation_start()
		else:
			SignalBus.play_sound.emit("transform_finish.ogg")
			transformation_end()
		
func transformation_start():
	SignalBus.in_transform = true
	color_check()
	color_switch(color_pointer)
	
func transformation_end():
	var final_color
	match color_pointer:
		0:
			final_color = SignalBus.Forms.FORM_WHITE
		1:
			final_color = SignalBus.Forms.FORM_YELLOW
		2:
			final_color = SignalBus.Forms.FORM_RED
		3:
			final_color = SignalBus.Forms.FORM_BLUE
	
	SignalBus.current_form = final_color
	SignalBus.in_transform = false
	overlay.visible = false
	PauseManager.set_paused(false, "transformation")
	
	SignalBus.finish_transformation.emit(SignalBus.current_state, final_color)
	SignalBus.hp_down.emit(transform_cost)
	
func color_check(): 
	form_color = SignalBus.current_form
	match form_color:
		SignalBus.Forms.FORM_WHITE:
			color_pointer = 0
		SignalBus.Forms.FORM_RED:
			color_pointer = 2
		SignalBus.Forms.FORM_BLUE:
			color_pointer = 3
		SignalBus.Forms.FORM_YELLOW:
			color_pointer = 1

	overlay.visible = true
	
	PauseManager.set_paused(true, "transformation")
		
# Checking the color of the indicator
func color_switch(pointer):
	match pointer:
		0:
			color_indicator.play("pick_white")
		1:
			color_indicator.play("pick_yellow")
		2:
			color_indicator.play("pick_red")
		3:
			color_indicator.play("pick_blue")
			
func if_paused():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func not_paused():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func pause_again():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
