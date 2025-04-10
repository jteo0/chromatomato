extends CanvasLayer

@export var next_scene: String = "res://scene/StageSelect.tscn"
@onready var levelname = $Control/LevelName

func _ready():
	SignalBus.level_done.connect(name_appear)
	$Control.modulate.a = 0
	$Control.scale = Vector2(0.5, 0.5)
	
	var tween_in = create_tween().set_trans(Tween.TRANS_BACK)
	tween_in.tween_property($Control, "modulate:a", 1, 0.5)
	tween_in.parallel().tween_property($Control, "scale", Vector2.ONE, 0.7)

	await tween_in.finished
	$Control/Timer.start()

func _on_timer_timeout():
	var tween_out = create_tween()
	tween_out.tween_property($Control, "modulate:a", 0, 0.5)
	await tween_out.finished
	queue_free()
	get_tree().change_scene_to_file(next_scene)

func name_appear(level_name):
	levelname.text = level_name + "\nComplete"
