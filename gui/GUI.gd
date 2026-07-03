extends CanvasLayer
class_name GUI

@onready var main_menu: Control = %MainMenu

func _ready() -> void:
	Story.connect("pause", _pause)

func _pause() -> void:
	main_menu.visible = !main_menu.visible

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("main_menu"):
		_pause()
