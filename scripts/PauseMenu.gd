extends Control

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and !PauseManager.pause_menu:
		pause()
	elif Input.is_action_just_pressed("escape") and PauseManager.pause_menu:
		resume()

func resume():
	if PauseManager.transformation_active:
		SignalBus.repause.emit()
		PauseManager.set_paused(false, "pause_menu")
		PauseManager.set_paused(true, "transformation")
	PauseManager.set_paused(false, "pause_menu")
	visible = false
	
func pause():
	PauseManager.set_paused(true, "pause_menu")
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
