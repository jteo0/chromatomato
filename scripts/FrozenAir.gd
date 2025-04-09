extends StaticBody2D

@export var lifetime: float = 1.5
var elapsed_time: float = 0.0
var timer_active: bool = true

func _ready():
	$AnimatedSprite2D.play("spawn_in")
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
	SignalBus.pause_pressed.connect(_on_pause_changed)

func _process(delta: float) -> void:
	if timer_active and not get_tree().paused:
		elapsed_time += delta
		if elapsed_time >= lifetime:
			queue_free()

func _on_pause_changed(active: bool):
	timer_active = !active
