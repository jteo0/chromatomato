extends Control

@onready var sfx = $SFX

func _ready() -> void:
	set_process(false)
	visible = false
	SignalBus.level_start.connect(_start)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if SignalBus.in_pause == false:
			pause()
		elif SignalBus.in_pause == true:
			resume()

func resume():
	get_tree().paused = false
	SignalBus.unpause.emit()
	visible = false
	SignalBus.in_pause = false
	
func pause():
	get_tree().paused = true
	SignalBus.is_paused.emit()
	visible = true
	SignalBus.in_pause = true

func _on_continue_button_pressed() -> void:
	sfx.play()
	resume()

func _on_restart_button_pressed() -> void:
	sfx.play()
	resume()
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	get_tree().change_scene_to_file(scene_path)

func _on_menu_button_pressed() -> void:
	sfx.play()
	resume()
	get_tree().change_scene_to_file("res://scene/MainMenu.tscn")
	
func _start():
	set_process(true)
