extends ProgressBar

@export var env_damage = 1
var health: int = _get_default_health() : set = _set_health

@onready var timer = $Timer
@onready var taken_bar = $TakenHealthBar

var is_active = false

func _get_default_health() -> int:
	if !Engine.is_editor_hint():  # Only run this logic in-game
		match SignalBus.level_playing:
			0: return 2000
			1: return 5000
			2: return 5500
			3: return 10000
	return 5000
	
func _ready() -> void:
	SignalBus.has_started.connect(_on_level_started)
	SignalBus.level_done.connect(done)
	if SignalBus.has_respawned:
		_on_level_started()

func _on_level_started():
	is_active = true
	SignalBus.hp_down.connect(countdown)
	SignalBus.turn_pausable.connect(if_paused)
	SignalBus.turn_always.connect(not_paused)
	SignalBus.repause.connect(pause_again)

func _process(_delta: float) -> void:
	print(health)

func _set_health(new_health):
	if not is_active: return
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
	if not is_active: return
	taken_bar.value = health

func countdown(hp_down):
	if not is_active: return
	_set_health(health - hp_down)
	
func if_paused():
	if not is_active: return
	process_mode = Node.PROCESS_MODE_PAUSABLE

func not_paused():
	if not is_active: return
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func pause_again():
	if not is_active: return
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

func done(_level):
	queue_free()
