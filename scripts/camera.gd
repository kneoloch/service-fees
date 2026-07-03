extends Camera3D
class_name Camera

var start_pos: Vector3 = Vector3(0, 5.5, 3.5)
var tween: Tween
var bob_tween: Tween
var bob_pos: Vector3

func start(start_position: Vector3) -> void:
	global_position = start_position

func move(to_position: Vector3, duration: float, target: Vector3) -> void: #Signal:
	bob_pos = to_position
	reset_tween()
	tween.tween_property(self, "global_position", to_position, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	if target == Vector3.ZERO:
		_reset_rotation()
		return
	#look_at(target)
	rotation_degrees = target
	print(target)

func _bob(to_position: Vector3) -> void:
	bob_tween.set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_LINEAR).set_loops()
	bob_tween.tween_property(self, "global_position", to_position + Vector3(0.01, 0.01, 0), 2)
	bob_tween.tween_property(self, "global_position", to_position + Vector3(-0.01, -0.01, 0), 2)

func _reset_rotation() -> void:
	rotation = Vector3.ZERO

func reset_tween() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	reset_bob()

func reset_bob() -> void:
	if bob_tween and bob_tween.is_running():
		bob_tween.kill()
	bob_tween = create_tween()
	_bob(bob_pos)
