extends Control

@onready var walking = $MarginContainer/VBoxContainer/HBoxContainer/Walking
@onready var jumping = $MarginContainer/VBoxContainer/HBoxContainer2/Jump
@onready var interacting = $MarginContainer/VBoxContainer/HBoxContainer3/Interact
@onready var transforming = $MarginContainer/VBoxContainer/HBoxContainer4/Transform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	walking.play("default")
	jumping.play("default")
	interacting.play("default")
	transforming.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/MainMenu.tscn")
