extends Node

@onready var hint_button = $Button

func _ready() -> void:
	if !SignalBus.skill_issue:
		hint_button.visible = false
		hint_button.disabled = true
	else:
		_show_hint()
	SignalBus.show_hint_button.connect(_show_hint)

func _on_button_pressed() -> void:
	SignalBus.show_hint.emit()

func _show_hint():
	hint_button.visible = true
	hint_button.disabled = false
