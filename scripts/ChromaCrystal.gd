extends Area2D

@export var total_tomato = 4.0
@export var level: String = "0: Beginning"
var taken_tomato = 0.0
var level_done = false

@onready var crystal_sprite = $CrystalSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crystal_sprite.play("default")
	
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
			complete_level()

func _on_crystal_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("player"):
		taken_tomato += SignalBus.player_tomato
		SignalBus.player_tomato = 0
		count_frac()

func complete_level():
	if !level_done:
		var congrats = preload("res://scene/Congrats.tscn").instantiate()
		get_tree().root.add_child(congrats)
		SignalBus.level_done.emit(level)
		level_done = true
