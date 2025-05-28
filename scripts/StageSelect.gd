extends Control

@onready var s1 = $MarginContainer/VBoxContainer/Stage1
@onready var s2 = $MarginContainer/VBoxContainer/Stage2
@onready var s3 = $MarginContainer/VBoxContainer/Stage3
@onready var sfx = $SFX

func _ready() -> void:
	var bgm = preload("res://assets/bgm/Funny Bit.ogg")  
	BgmManager.play_bgm(bgm)
	s3.disabled = true
	s2.disabled = true
	s1.disabled = true

func _process(_delta: float) -> void:
	if SignalBus.unlocked_level > 0:
		s1.disabled = false
		if SignalBus.unlocked_level > 1:
			s2.disabled = false
			if SignalBus.unlocked_level > 2:
				s3.disabled = false

func _on_stage_0_pressed() -> void:
	sfx.play()
	SignalBus.level_playing = 0
	SignalBus.respawn_count = 0
	SignalBus.skill_issue = false
	get_tree().change_scene_to_file("res://scene/Level0.tscn")

func _on_stage_1_pressed() -> void:
	sfx.play()
	SignalBus.level_playing = 1
	SignalBus.respawn_count = 0
	SignalBus.skill_issue = false
	get_tree().change_scene_to_file("res://scene/Level1.tscn")

func _on_stage_2_pressed() -> void:
	sfx.play()
	SignalBus.level_playing = 2
	SignalBus.respawn_count = 0
	SignalBus.skill_issue = false
	get_tree().change_scene_to_file("res://scene/Level2.tscn")
	
func _on_stage_3_pressed() -> void:
	sfx.play()
	SignalBus.level_playing = 3
	SignalBus.respawn_count = 0
	SignalBus.skill_issue = false
	get_tree().change_scene_to_file("res://scene/Level3.tscn")

func unlock(level):
	match level:
		"0: Beginning":
			s1.disabled = false
		"1: Jump":
			s2.disabled = false
		"2: Break":
			s3.disabled = false
		"3: Tower":
			pass

func _on_back_button_pressed() -> void:
	$SFX.play()
	get_tree().change_scene_to_file("res://scene/MainMenu.tscn")
