extends ProgressBar

@export var env_damage = 1
var health: int = _get_default_health() : set = _set_health

@onready var timer = $Timer
@onready var taken_bar = $TakenHealthBar

var is_active = false

func _get_default_health() -> int:
	if !Engine.is_editor_hint():
		match SignalBus.level_playing:
			0: return 5000
			1: return 5000
			2: return 4000
			3: return 5000
	return 5000
	
func _ready() -> void:
	set_process(false)
	
	SignalBus.level_start.connect(_unpause)
	SignalBus.level_done.connect(done)
	SignalBus.hp_down.connect(countdown)
	SignalBus.is_paused.connect(_pause)
	SignalBus.unpause.connect(_unpause)

func _process(_delta: float) -> void:
	if SignalBus.in_transform:
		env_damage = 2
	else:
		env_damage = 1
	countdown(env_damage)
	print(health)

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
		taken_bar.value = health

func init_health(_health):
	max_value = _health
	health = _health
	value = health
	taken_bar.max_value = health
	taken_bar.value = health

func _on_timer_timeout() -> void:
	taken_bar.value = health

func countdown(hp_down):
	_set_health(health - hp_down)

func done(_level):
	queue_free()
	
func _pause():
	set_process(false)
	
func _unpause():
	set_process(true)
