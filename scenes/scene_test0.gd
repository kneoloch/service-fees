extends Scene
class_name SceneTest0

const ICON = preload("uid://bvb3gj7fi6u1c")
var panels_visible: Array = []

var script_lines: Array[Dictionary] = [
	add_narration_box("At this moment, I didn't know what to do anymore.", Vector2(-100, -100), default_size, ColorTheme.LIGHT, "_test"),
	add_narration_box("No.", center, default_size, ColorTheme.LIGHT, ""),
	add_narration_box("It was impossible.", Vector2(100, 100), default_size, ColorTheme.LIGHT, ""),
	]

func _test() -> void:
	var new_sprite: TextureRect = TextureRect.new()
	get_tree().get_first_node_in_group("panels").add_child(new_sprite)
	new_sprite.texture = ICON
	panels_visible.append(new_sprite)
