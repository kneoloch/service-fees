extends Node
class_name StoryManager 

#const align_center: Vector2 = Vector2(0.5, 0.5)
#const offset_right: Vector2 = Vector2(0.75, 0.75)
@export var text_layer: Control
@export var NARRATIVE_TEXT: PackedScene
@export var camera: Camera3D
#@onready var left_center: Vector2 = Vector2(left.position + center.position / 2) * align_center
#@onready var align_top_center: Vector2 = Vector2(top_left.position + center.position / 2) * offset_right

var rewind: bool = false
var line_index: int = -1
var max_index: Array = []

func _ready() -> void:
	camera.start(camera.start_pos)

func _unhandled_input(event: InputEvent) -> void:
	match event.get_class():
		"InputEventMouseButton", "InputEventScreenTouch":
			if event.pressed and not event.is_echo():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						_advance()
	
	if event.is_action_released("forward"):
		if line_index >= max_index.size() - 1:
			return
		_advance()
	if event.is_action_released("rewind"):
		_rewind()

func _rewind() -> void:
	if camera.tween and camera.tween.is_running():
		camera.tween.custom_step(5.0)
		return
	rewind = true
	_load_script()

func _advance() -> void:
	if camera.tween and camera.tween.is_running():
		camera.tween.custom_step(5.0)
		return
	line_index += 1
	_load_script()

func _load_script() -> void:
	var script_array: Array[Dictionary] = [
		cam(Vector3(0, 0, 3.5), 2), 
		n("The princess's idea of a joke.", Vector3(-1.5, 1.3, 0.5), 32)
	]
	if line_index <= -1:
		line_index = -1
		rewind = false
		return
	if line_index >= script_array.size():
		line_index = script_array.size() - 1
		return
	var line: Variant = script_array.get(line_index)
	var executable: String = line["EXECUTE"]
	var callable = Callable(self, executable)
	
	if rewind:
		match executable:
			"move_cam":
				if line_index <= 0:
					callable.call(camera.start_pos, line["DURATION"]/2)
					print_rich("[color=gray]<< [b]Scene 0 | Line_%d:[/b] \n  [color=gray]<< [rewind] %s%s, %d secs" % [line_index - 1, line["EXECUTE"], str(camera.start_pos), line["DURATION"]])
				else:
					callable.call(line["TO_POSITION"], line["DURATION"]/2)
					print_rich("[color=gray]<< [b]Scene 0 | Line_%d:[/b] \n  [color=gray]<< [rewind] %s%s, %d secs" % [line_index - 1, line["EXECUTE"], str(line["TO_POSITION"]), line["DURATION"]])
			"narrate":
				text_layer.get_node("Line_" + str(line_index + 1)).queue_free()
				print_rich("[color=gray]<< [b]Scene 0 | Line_%d:[/b] \n  [color=gray]<< [hide] '%s'" % [line_index - 1, line["TEXT"]])
		line_index -= 1
		rewind = false
	else:
		match executable:
			"move_cam":
				callable.call(line["TO_POSITION"], line["DURATION"])
				print_rich(">> [b]Scene 0 | Line_%d:[/b] \n  [color=aqua]>> %s%s, %d secs" % [line_index, line["EXECUTE"], str(line["TO_POSITION"]), line["DURATION"]])
			"narrate":
				callable.call(line["TEXT"], line["POSITION"], line["SIZE_FONT"])
				print_rich(">> [b]Scene 0 | Line_%d:[/b] \n  [color=yellow]>> '%s'" % [line_index, line["TEXT"]])
		if !max_index.has(line_index):
			max_index.append(line_index)

func cam(to_position: Vector3, duration: float) -> Dictionary:
	var camera_move: Dictionary = {
		"TO_POSITION": to_position, 
		"DURATION": duration,
		"EXECUTE": "move_cam"
	}
	return camera_move

func move_cam(to_position: Vector3, duration: float) -> void:
	camera.move(to_position, duration)

func n(text: String, position: Vector3, size_font: int) -> Dictionary:
	var narration: Dictionary = {
		"TEXT": text, 
		"POSITION": position,
		"SIZE_FONT": size_font,
		"EXECUTE": "narrate"
	}
	return narration

func narrate(text: String, position: Vector3, size_font: int) -> void:
	var narrate_text: Label3D = NARRATIVE_TEXT.instantiate()
	text_layer.add_child(narrate_text)
	narrate_text.name = "Line_" + str(line_index + 1)
	narrate_text.text = text
	narrate_text.font_size = size_font
	narrate_text.global_position = position
