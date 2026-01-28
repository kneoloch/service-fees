extends Node
class_name StoryScript

@export var current_scene: Scene
var scene_index: int = 0
var line: int = -1

func _ready() -> void:
	get_scene_index()

## Current scene index
func get_scene_index() -> void:
	for scene: int in get_child_count():
		if get_child(scene) == current_scene:
			scene_index = scene

## Scene switcher: change to scene index
func _jump_to(scene: int) -> void:
	if !scene >= get_child_count():
		current_scene = get_child(scene)

func check_for_text() -> bool:
	## Advance to next line in the current scene's script
	line += 1
	## End of scene:
	if line >= current_scene.script_lines.size():
		scene_index += 1
		line = 0
		_jump_to(scene_index)
		print("\n")
	print("Scene %s | Line_%d" % [get_child(scene_index).name, line + 1])
	
	## End of story:
	if scene_index == get_child_count() - 1 and line == current_scene.script_lines.size() - 1:
		Story.end = true
	
	if !current_scene.script_lines.get(line).has("TEXT"):
		return false
	
	print_rich("- [i]%s" %current_scene.script_lines.get(line)["TEXT"])
	return true

func get_line() -> String:
	return current_scene.script_lines.get(line)["TEXT"]

func get_pos() -> Vector2:
	if line >= current_scene.script_lines.size():
		line = -1
		return Vector2()
	else:
		return current_scene.script_lines.get(line)["POSITION"]

func check_for_executable() -> bool:
	var current_line: int = line
	if line == -1:
		current_line = 0
	if current_scene.script_lines.get(current_line)["METHOD"] == "":
		return false
	else:
		print("-- Executing method: %s" % current_scene.script_lines.get(current_line)["METHOD"])
		var callable = Callable(current_scene, str(current_scene.script_lines.get(current_line)["METHOD"]))
		callable.call()
		return true
