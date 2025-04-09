extends Control

@onready var time_label = $VBoxContainer/TimeLabel

func _ready() -> void:
	visible = false
	SignalBus.level_done.connect(end_appear)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func end_appear():
	visible = true

func _on_next_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file("res://scene/LevelSelect.tscn")
