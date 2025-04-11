extends Area2D

@onready var animated_player = $AnimatedSprite2D

var is_collected: bool = false

var bob_height: float = 12.0
var bob_speed: float = 1.5
var random_offset: float = 0.0

var start_y: float = 0.0

func _ready():
	animated_player.play("default")
	
	self.start_y = position.y
	random_offset = randf_range(0, 2 * PI)

func _process(_delta):
	var time = Time.get_ticks_msec() / 1000.0
	self.position.y = start_y + sin(time * bob_speed + random_offset) * bob_height

func _on_chromatomato_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player") and !self.is_collected:
		self.is_collected = true
		SignalBus.tomato_pickup.emit()
		SignalBus.play_sound.emit("Fruit collect 1.wav")
		self.visible = false
