extends Node
class_name Scene

enum ColorTheme {LIGHT, DARK, CUSTOM}
var center: Vector2 = Vector2()
var default_size: Vector2 = Vector2(200, 0)

func cam(to_position: Vector3, duration: float, target: Vector3) -> Dictionary:
	var camera_move: Dictionary = {
		"TO_POSITION": to_position, 
		"DURATION": duration,
		"TARGET": target,
		"EXECUTE": "move_cam"
	}
	return camera_move

func cam_switch(c: int) -> Dictionary:
	var camera_switch: Dictionary = {
		"CAMERA_INDEX": c,
		"EXECUTE": "switch_cam"
	}
	return camera_switch

func light(l: int) -> Dictionary:
	var lighting: Dictionary = {
		"LIGHT_INDEX": l,
		"EXECUTE": "cue_lighting"
	}
	return lighting

#func n(text: String, position: Vector3, size_font: int, color: Color, clear_retained: bool) -> Dictionary:
	#var narration: Dictionary = {
		#"TEXT": text, 
		#"POSITION": position,
		#"SIZE_FONT": size_font,
		#"COLOR": color,
		#"CLEAR_RETAINED": clear_retained,
		#"EXECUTE": "narrate"
	#}
	#return narration
