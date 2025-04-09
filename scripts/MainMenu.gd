extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_start_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/Level1.tscn")

func _on_exit_menu_button_pressed() -> void:
	get_tree().quit()

func _on_controls_menu_button_pressed() -> void:
	pass
