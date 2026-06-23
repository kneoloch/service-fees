extends Camera3D
class_name Camera

var start_pos: Vector3 = Vector3(0, 5.5, 3.5)
#var prev_pos: Vector3
#var curr_pos: Vector3
var tween: Tween

func start(start_position: Vector3) -> void:
	global_position = start_position
	#curr_pos = start_pos

func move(to_position: Vector3, duration: float) -> Signal:
	#prev_pos = curr_pos
	#print("prev: ", prev_pos)
	#curr_pos = to_position
	#print("curr: ", curr_pos)
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", to_position, duration)
	tween.tween_callback(set_process.bind(true))
	#tween.connect("finished", on_tween_finished)
	return tween.finished

func skip() -> void:
	if tween and tween.is_running():
		tween.kill()
