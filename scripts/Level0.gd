extends Node2D

func _ready():
	var cutscene_system = Node.new()
	cutscene_system.name = "CutsceneSystem"
	add_child(cutscene_system)
	
	var camera = preload("res://scene/CutsceneCamera.tscn").instantiate()
	cutscene_system.add_child(camera)
	
	$CutsceneSystem/CutsceneCamera.start_cutscene()
	$Cutscene.play_opening()

func toggle_camera(active: bool):
	if active:
		$CutsceneSystem/CutsceneCamera.make_current()
		$Player/Camera2D.enabled = false
	else:
		$Player/Camera2D.make_current()
		$CutsceneSystem/CutsceneCamera.enabled = false
