extends Area2D

var hp = 1
var its_in = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	hp += 0.5
	if its_in:
		SignalBus.hp_down.emit(hp)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		its_in = true
