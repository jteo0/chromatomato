extends Control

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func resume():
	SignalBus.pause_pressed.emit(false)
	get_tree().paused = false
	visible = false
	
func pause():
	SignalBus.pause_pressed.emit(true)
	get_tree().paused = true
	visible = true

func _on_continue_button_pressed() -> void:
	resume()

func _on_restart_button_pressed() -> void:
	resume()
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	get_tree().change_scene_to_file(scene_path)

func _on_menu_button_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scene/MainMenu.tscn")
