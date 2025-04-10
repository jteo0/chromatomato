extends Control

@onready var time_label = $CongratsBox/TimeLabel
@onready var congratulations = $CongratsBox/Congratulations
@onready var win_text = $CongratsBox

func _ready() -> void:
	win_text.visible = false

func _on_stage_0_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/Level0.tscn")
