extends ProgressBar

@export var env_damage = 1

@onready var timer = $Timer
@onready var taken_bar = $TakenHealthBar

var health = 0 : set = _set_health

func _ready() -> void:
	SignalBus.hp_down.connect(countdown)
	SignalBus.turn_pausable.connect(if_paused)
	SignalBus.turn_always.connect(not_paused)
	SignalBus.repause.connect(pause_again)

func _process(_delta: float) -> void:
	countdown(env_damage)

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		set_process(false)
		SignalBus.dead.emit()
		var death_screen = preload("res://scene/Dead.tscn").instantiate()
		get_tree().root.add_child(death_screen)
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
	
func if_paused():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func not_paused():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func pause_again():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
