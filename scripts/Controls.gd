extends Control

@onready var walking = $Walking
@onready var jumping = $Jump
@onready var interacting = $Interact
@onready var transforming = $Transform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	walking.play("default")
	jumping.play("default")
	interacting.play("default")
	transforming.play("default")

func _on_back_button_pressed() -> void:
	$SFX.play()
	get_tree().change_scene_to_file("res://scene/MainMenu.tscn")
