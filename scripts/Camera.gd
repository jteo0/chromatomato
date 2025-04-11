extends Node

@export var linger_time := 1.5
@export var move_duration := 2.0 

@onready var player = $Player
@onready var camera = $Player/Camera2D
@onready var sfx = $SFX
@onready var sfx_transform = $SFXTransform
@onready var sfx_ui = $SFXUI

func _ready():
	SignalBus.level_playing = 2
	var bgm = preload("res://assets/bgm/retro-gaming-248421.ogg")  
	BgmManager.play_bgm(bgm)		
	
	SignalBus.play_sound.connect(play_sound)
	if not SignalBus.has_respawned:
		play_intro_sequence()

func play_intro_sequence():
	var original_offset = camera.position
	var level_end = $ChromaCrystal
	camera.position = level_end.position - player.position
	
	await get_tree().create_timer(linger_time).timeout
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "position", original_offset, move_duration)
	
	await tween.finished
	SignalBus.has_started.emit()

func _on_player_respawned():
	camera.position = Vector2.ZERO 

func play_sound(sound_name: String):
	var sound_path = "res://assets/sounds/" + sound_name
	var sound_stream = load(sound_path)
	
	if sound_stream == null:
		push_error("Sound not found: " + sound_path)
		return
	
	if sound_name == "transform_finish.mp3" or sound_name == "transform_start.ogg":
		sfx_transform.stream = sound_stream
		sfx_transform.play()
	
	elif sound_name == "Fruit collect 1.wav" or sound_name == "win.mp3" or sound_name == "lose.wav":
		sfx_ui.stream = sound_stream
		sfx_ui.play()
		
	else:
		sfx.stream = sound_stream
		sfx.play()
