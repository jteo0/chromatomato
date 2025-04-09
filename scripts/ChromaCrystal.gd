extends Area2D

@export var total_tomato = 4.0
var taken_tomato = 0.0

@onready var crystal_sprite = $CrystalSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crystal_sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func count_frac():
	var frac = taken_tomato / total_tomato
	match frac:
		0.0:
			crystal_sprite.play("default")
		0.25:
			crystal_sprite.play("quarterdown")
		0.5:
			crystal_sprite.play("half")
		0.75:
			crystal_sprite.play("quarterup")
		1.0:
			crystal_sprite.play("full")
			SignalBus.level_done.emit()

func _on_crystal_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		taken_tomato += SignalBus.player_tomato
		SignalBus.player_tomato = 0
		count_frac()
		print("Taken: ", taken_tomato)
