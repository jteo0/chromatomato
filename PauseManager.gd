extends Node

var transformation_active := false

func set_paused(paused: bool, requester: String = "default"):
	match requester:
		"pause_menu":
			get_tree().paused = paused
		"transformation":
			transformation_active = !paused
			_update_pause_state()
			
func _update_pause_state():
	get_tree().paused = transformation_active
