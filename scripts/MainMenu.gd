extends Control

@onready var tomato = $MarginContainer/VBoxContainer/Control/AnimatedSprite2D
@onready var sfx = $SFX

var bob_height: float = 15.0
var bob_speed: float = 1.5
var random_offset: float = 0.0

var start_y: float = 0.0

func _ready():
	var bgm = preload("res://assets/bgm/Funny Bit.ogg")  
	BgmManager.play_bgm(bgm)
	
	tomato.play("default")
	start_y = tomato.position.y
	random_offset = randf_range(0, 2 * PI)
	
func _process(_delta):
	var time = Time.get_ticks_msec() / 1000.0
	tomato.position.y = start_y + sin(time * bob_speed + random_offset) * bob_height

func _on_start_menu_button_pressed() -> void:
	sfx.play()
	get_tree().change_scene_to_file("res://scene/StageSelect.tscn")

func _on_exit_menu_button_pressed() -> void:
	sfx.play()
	get_tree().quit()

func _on_controls_menu_button_pressed() -> void:
	sfx.play()
	get_tree().change_scene_to_file("res://scene/ControlsScreen.tscn")
