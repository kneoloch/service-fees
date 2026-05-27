extends Node3D
class_name TitleMenu

@onready var return_option: CSGBox3D = %Return
@onready var starting_color: Color = return_option.material.get("albedo_color")

func _ready() -> void:
	Animations.mainMenuAnim.connect(_return)

func _return(_visible: bool) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector3(0.8, 0, 0), 2.5).set_trans(Tween.TRANS_ELASTIC)
	await get_tree().create_timer(2.5).timeout
	for item: Node in get_tree().get_nodes_in_group("main_menu"):
		item.hide()
		Story.paused = false

func _on_return_area_mouse_entered() -> void:
	return_option.material.set("albedo_color", starting_color + Color(0.5, 0.5, 0.5))

func _on_return_area_mouse_exited() -> void:
	return_option.material.set("albedo_color", starting_color)

func _on_return_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	_left_click(event)

func _on_new_game_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	_left_click(event)

func _left_click(event: InputEvent) -> void:
	match event.get_class():
		"InputEventMouseButton", "InputEventScreenTouch":
			if event.pressed and not event.is_echo():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						_return(false)
	
	if event.is_action_released("ui_accept"):
		_return(false)
