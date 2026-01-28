extends Node
class_name Scene

enum ColorTheme {LIGHT, DARK, CUSTOM}
var center: Vector2 = Vector2()
var default_size: Vector2 = Vector2(200, 0)

func add_narration_box(text: String, position: Vector2, size: Vector2, color_theme: ColorTheme, method: String) -> Dictionary:
	var narration: Dictionary = {
		"TEXT": text, 
		"POSITION": position,
		"SIZE": size, 
		"COLOR_THEME": color_theme,
		"METHOD": method
	}
	return narration

func add_method(method: String) -> Dictionary:
	var executable: Dictionary = {
		"METHOD": method
	}
	return executable
