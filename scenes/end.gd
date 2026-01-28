extends Scene
class_name End

var script_lines: Array[Dictionary] = [
	add_narration_box("Cool!", center, default_size, ColorTheme.LIGHT, ""),
	add_narration_box("The End", center, default_size, ColorTheme.LIGHT, "_end"),
	add_method("_fr")
	]

func _end() -> void:
	print("WHOOOOOOOOOOO!")
	
func _fr() -> void:
	print("the end fr")
