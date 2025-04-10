extends Node

var transformation_active := false
var pause_menu := false

func set_paused(paused: bool, requester: String = "default"):
	match requester:
		"pause_menu":
			SignalBus.turn_pausable.emit()
			get_tree().paused = paused
			if transformation_active and !pause_menu and !paused:
				SignalBus.turn_always.emit()
			pause_menu = paused
		"transformation":
			if pause_menu:
				SignalBus.turn_pausable.emit()
			elif !pause_menu:
				SignalBus.turn_always.emit()
				transformation_active = paused
			get_tree().paused = paused
