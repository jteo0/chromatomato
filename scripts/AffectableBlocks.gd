extends RigidBody2D

@export var freeze_duration := 2.0
@export var shake_intensity: float = 5.0
@export var shake_duration: float = 0.3

@onready var animated_player = $AnimatedSprite2D
@onready var original_position = position

var original_mode = freeze_mode
var original_free = freeze
var original_layer = collision_layer
var original_mask = collision_mask

func _ready() -> void:
	animated_player.play("default")
	SignalBus.freeze_me.connect(freeze_block)
	SignalBus.push_me.connect(push_block)
	SignalBus.break_me.connect(break_block)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func freeze_block(me):
	if me == self:
		animated_player.play("blue")
		freeze = true
		get_tree().create_timer(freeze_duration).timeout.connect(unfreeze_block)
		
func unfreeze_block():
	freeze = false
	animated_player.play("default")

func push_block(me, dir):
	if me != self:
		return
	
	animated_player.play("red")
	
	# Apply impulse force (adjust strength as needed)
	var push_force = dir * 2000  # Strong instant force
	apply_impulse(push_force)
	
	# Optional: Limit max speed
	var speed_limit_tween = create_tween()
	speed_limit_tween.tween_method(
		_limit_speed.bind(300),  # Max pixels/second
		0, 1, 0.5
	)

func _limit_speed(max_speed: float, _progress: float):
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

func restore_physics():
	freeze = false
	collision_layer = original_layer
	collision_mask = original_mask
	
func break_block(me):
	if me == self:
		animated_player.play("yellow")
		
		var original_pos = me.global_position
		var tween = get_tree().create_tween()
		tween.set_loops(3)
		tween.tween_property(me, "global_position", original_pos + Vector2(5, 0), 0.05)
		tween.tween_property(me, "global_position", original_pos - Vector2(5, 0), 0.05)
		tween.tween_property(me, "global_position", original_pos, 0.05)
		tween.tween_callback(Callable(me, "queue_free"))
		
		await tween.finished
		SignalBus.play_sound.emit("Block Break 1.wav")
