extends Control

@export var target_pos: Vector2

@onready var arrow = $AnimatedSprite2D
@onready var anchor = get_parent().get_parent().find_child("Player")

var anchor_pos
var camera_zoom

func _ready() -> void:
	arrow.visible = false
	set_process(false)
	camera_zoom = get_viewport().get_camera_2d().zoom
	SignalBus.show_hint.connect(_show_hint)
	
func _process(delta: float) -> void:
	if target_pos == Vector2.ZERO: return
	
	var target_screen_pos = (target_pos -  anchor.global_position * camera_zoom)
	
	if _target_on_screen():
		global_position = target_pos
	else:
		_set_screen_position(target_pos)
		_rotate_to_target()
	
func _show_hint():
	arrow.visible = true
	set_process(true)
	
func _get_camera_rect():
	var pos = anchor.global_position
	var screensize = get_viewport_rect().size / camera_zoom
	
	return Rect2(pos - screensize/2, screensize)

func _target_on_screen():
	return _get_camera_rect().has_point(target_pos)
	
func _set_screen_position(screen_target_pos):
	var screensize = get_viewport_rect().size
	var border_offset = 50
	var target_position = screen_target_pos
	
	if target_position.x < border_offset:
		target_position.x = border_offset
	if target_position.x > screensize.x - border_offset:
		target_position.x = screensize.x - border_offset
	if target_position.y < border_offset:
		target_position.y = border_offset
	if target_position.y > screensize.y - border_offset:
		target_position.y = screensize.y - border_offset
		
	global_position = target_position

func _rotate_to_target():
	var current_position = anchor.global_position
	var direction = (target_pos - current_position).normalized()
	
	rotation = direction.angle()
