extends Control

@onready var walking = $MarginContainer/VBoxContainer/HBoxContainer/Control/Walking
@onready var jumping = $MarginContainer/VBoxContainer/HBoxContainer/Control2/Jump
@onready var interacting = $MarginContainer/VBoxContainer/HBoxContainer/Control3/Interact
@onready var transforming = $MarginContainer/VBoxContainer/HBoxContainer/Control4/Transform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	walking.play("default")
	jumping.play("default")
	interacting.play("default")
	transforming.play("default")

func _on_back_button_pressed() -> void:
	$SFX.play()
	get_tree().change_scene_to_file("res://scene/MainMenu.tscn")
