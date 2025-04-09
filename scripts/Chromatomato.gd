extends Area2D

@onready var animated_player = $AnimatedSprite2D

var is_collected: bool = false

func _ready():
	animated_player.play("default")
	SignalBus.tomato_give.connect(to_crystal)

func _on_chromatomato_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player") and !self.is_collected:
		self.is_collected = true
		SignalBus.tomato_pickup.emit()
		follow_player()
		print("caught: tomato")

# follow the player after being picked up
func follow_player():
	pass

# Either move into the crystal or just disappear, preferably with an animation
func to_crystal():
	if self.is_collected:
		self.visible = false
