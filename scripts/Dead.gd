extends CanvasLayer

@onready var deadtext = $Control/DeadText
var previous_scene: String

func _ready():
	previous_scene = _find_previous_scene_path()
	
	_connect_signal()
	
	_start_death_sequence()

func _find_previous_scene_path() -> String:
	for child in get_tree().root.get_children():
		if not child is CanvasLayer and child != self:
			return child.scene_file_path
	return ""  # Fallback

func _connect_signal():
	if SignalBus.has_signal("dead"):
		if !SignalBus.dead.is_connected(_on_dead):
			SignalBus.dead.connect(_on_dead, CONNECT_DEFERRED)
	else:
		printerr("SignalBus.dead signal missing!")
		call_deferred("_on_dead")  # Fallback

func _start_death_sequence():
	SignalBus.play_sound.emit("lose.wav")
	$Control.modulate.a = 0
	$Control.scale = Vector2(0.5, 0.5)
	_on_dead()

func _on_dead():
	deadtext.text = "DEAD"
	
	var tween = create_tween()
	tween.tween_property($Control, "modulate:a", 1, 0.5)
	tween.parallel().tween_property($Control, "scale", Vector2.ONE, 0.7)
	
	await tween.finished
	await get_tree().create_timer(2.0).timeout
	
	tween = create_tween()
	tween.tween_property($Control, "modulate:a", 0, 0.3)
	await tween.finished
	
	SignalBus.has_respawned = true
	
	if previous_scene and ResourceLoader.exists(previous_scene):
		get_tree().change_scene_to_file(previous_scene)
	else:
		get_tree().reload_current_scene()
	
	queue_free()
