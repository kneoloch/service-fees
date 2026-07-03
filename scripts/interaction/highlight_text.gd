extends Area3D

@export var mesh: MeshInstance3D
@export var text: Label3D
@export var text_color: Sprite3D
@export var box_highlight: Sprite3D
@export var box_shadow: Sprite3D
var tween: Tween
var tween2: Tween

func _ready() -> void:
	tween = create_tween().set_loops()
	tween.set_loops()
	tween.tween_property(box_highlight, "global_position", box_highlight.global_position + Vector3(0.01, 0.01, 0), 0.5)
	tween.tween_property(box_highlight, "global_position", box_highlight.global_position + Vector3(-0.01, -0.01, 0), 0.5)
	tween2 = create_tween().set_loops()
	tween2.set_loops()
	tween2.tween_property(box_shadow, "global_position", box_shadow.global_position + Vector3(-0.01, -0.01, 0), 0.8)
	tween2.tween_property(box_shadow, "global_position", box_shadow.global_position + Vector3(0.01, 0.01, 0), 0.8)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	match event.get_class():
		"InputEventMouseButton", "InputEventScreenTouch":
			if event.pressed and not event.is_echo():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						mesh.visible = !mesh.visible    

func _on_mouse_entered() -> void:
	Story.object_collision = true
	text_color.modulate = Color.html("#0f0700")
	box_highlight.modulate = Color.html("#97cd2d") 
	box_shadow.modulate = Color.html("#0f0700") 

func _on_mouse_exited() -> void:
	Story.object_collision = false
	text_color.modulate = Color.html("#f2d3a7")
	box_highlight.modulate = Color.html("#0f0700")
	box_shadow.modulate = Color.html("#97cd2d") 
