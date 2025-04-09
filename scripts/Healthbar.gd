extends ProgressBar

@export var env_damage = 1

@onready var timer = $Timer
@onready var taken_bar = $TakenHealthBar

var health = 0 : set = _set_health

func _ready() -> void:
	SignalBus.hp_down.connect(countdown)
	SignalBus.pause_pressed.connect(pause_bar)

func _process(delta: float) -> void:
	countdown(env_damage)

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health < prev_health:
		timer.start()
	else:
		if taken_bar != null:
			taken_bar.value = 50.0
		else:
			push_error("TakenHealthBar is missing or not a ProgressBar!")

func init_health(_health):
	health = _health
	max_value = health
	value = health
	taken_bar.max_value = health
	taken_bar.value = health

func _on_timer_timeout() -> void:
	taken_bar.value = health

func countdown(hp_down):
	_set_health(health - hp_down)
	
func pause_bar(active: bool):
	set_process(!active)
