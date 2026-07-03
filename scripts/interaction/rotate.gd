extends Node3D
class_name Rotate

@export var object: MeshInstance3D

var tween: Tween
var end: Vector3 = Vector3(0, 360, 0)
var start: Vector3 = Vector3(0, 0, 0)

func _ready() -> void:
	tween = create_tween().set_loops()
	tween.tween_property(object, "rotation_degrees", end, 6.0).from(start)
