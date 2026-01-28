extends Node3D
class_name TitleMenu

@onready var return_option: CSGBox3D = %Return
@onready var starting_color: Color = return_option.material.get("albedo_color")

func _on_return_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	match event.get_class():
		"InputEventMouseButton", "InputEventScreenTouch":
			if event.pressed and not event.is_echo():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						_return()
	
	#if event.is_action_released("ui_accept"):
		#pass

func _return() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector3(0.8, 0, 0), 2.5).set_trans(Tween.TRANS_ELASTIC)

func _on_return_area_mouse_entered() -> void:
	return_option.material.set("albedo_color", starting_color + Color(0.5, 0.5, 0.5))

func _on_return_area_mouse_exited() -> void:
	return_option.material.set("albedo_color", starting_color)
