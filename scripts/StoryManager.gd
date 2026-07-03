extends Node
class_name StoryManager 


@export var text_layer: Node3D
@export var NARRATIVE_TEXT: PackedScene
@export var camera: Camera3D
@export var stage_light: Light3D
@export var current_script: Scene
@onready var SCRIPT: Array = current_script.script_array
@onready var cams_arr: Array = get_tree().get_nodes_in_group("cameras")
@onready var lights_arr: Array = get_tree().get_nodes_in_group("stage_light")
var rewind: bool = false
var line_index: int = -1
var max_lines_index: Array = []

func _ready() -> void:
	camera.start(camera.start_pos)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("forward"):
		if line_index >= max_lines_index.size() - 1:
			return
		_advance()
	if event.is_action_released("rewind"):
		_rewind()
	
	if Story.object_collision:
		return
	
	match event.get_class():
		"InputEventMouseButton", "InputEventScreenTouch":
			if event.pressed and not event.is_echo():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						_advance()

func _rewind() -> void:
	if camera.tween and camera.tween.is_running():
		camera.tween.custom_step(5.0)
		camera.reset_bob()
		return
	rewind = true
	_load_script()

func _advance() -> void:
	if camera.tween and camera.tween.is_running():
		camera.tween.custom_step(5.0)
		camera.reset_bob()
		return
	line_index += 1
	_load_script()

func _load_script() -> void:
	if line_index <= -1:
		line_index = -1
		rewind = false
		return
	if line_index >= SCRIPT.size():
		line_index = SCRIPT.size() - 1
		return
	
	var lines: Array = SCRIPT.get(line_index)
	for i in lines.size():
		var function: int = i
		var line: Variant = SCRIPT.get(line_index)[i]
		var executable: String = line["EXECUTE"]
		var callable: Callable = Callable(self, executable)
		_execute_story(function, line, executable, callable)
	
	if rewind:
		line_index -= 1
		rewind = false
		
func _execute_story(function: int, line: Variant, executable: String, callable: Callable) -> void:
	if rewind:
		match executable:
			"move_cam":
				if line_index <= 0:
					callable.call(camera.start_pos, line["DURATION"]/2, line["TARGET"])
					print_rich("[color=gray]<< [b]Scene 0 | Line_%d:[/b] \n  [color=gray]<< [rewind] %s%s, %d secs" % [line_index - 1, line["EXECUTE"], str(camera.start_pos), line["DURATION"]/2])
				else:
					line = SCRIPT.get(line_index - 1)[function]
					callable.call(line["TO_POSITION"], line["DURATION"]/2, line["TARGET"])
					print_rich("[color=gray]<< [b]Scene 0 | Line_%d:[/b] \n  [color=gray]<< [rewind] %s%s, %d secs" % [line_index - 1, line["EXECUTE"], str(line["TO_POSITION"]), line["DURATION"]/2])
			#"narrate":
				#text_layer.get_node("Line_" + str(line_index)).queue_free()
				#if text_layer.get_child(line_index - 1):
					#text_layer.get_child(line_index - 1).show()
					#print("show: line ", line_index - 1)
				#print_rich("[color=gray]<< [b]Scene 0 | Line_%d:[/b] \n  [color=gray]<< [hide] '%s'" % [line_index - 1, line["TEXT"]])
			"switch_cam":
				callable.call(line["CAMERA_INDEX"] - 1)
				print_rich("  [color=gray]<< Switch to cam_%d" % (line["CAMERA_INDEX"] - 1))
			"cue_lighting":
				callable.call(line["LIGHT_INDEX"] - 1)
				print_rich("  [color=gray]<< Cue light_%d" % (line["LIGHT_INDEX"] - 1))
	else:
		match executable:
			"move_cam":
				callable.call(line["TO_POSITION"], line["DURATION"], line["TARGET"])
				print_rich(">> [b]Scene 0 | Line_%d:[/b] \n  [color=aqua]>> %s%s, %d secs" % [line_index, line["EXECUTE"], str(line["TO_POSITION"]), line["DURATION"]])
			#"narrate":
				#callable.call(line["TEXT"], line["POSITION"], line["SIZE_FONT"], line["COLOR"], line["CLEAR_RETAINED"])
				#print_rich(">> [b]Scene 0 | Line_%d:[/b] \n  [color=yellow]>> '%s'" % [line_index, line["TEXT"]])
			"switch_cam":
				callable.call(line["CAMERA_INDEX"])
				print_rich("  [color=gray]>> Switch to cam_%d" % (line["CAMERA_INDEX"]))
			"cue_lighting":
				callable.call(line["LIGHT_INDEX"])
				print_rich("  [color=gray]>> Cue light_%d" % (line["LIGHT_INDEX"]))
		if !max_lines_index.has(line_index):
			max_lines_index.append(line_index)

func move_cam(to_position: Vector3, duration: float, target: Vector3) -> void:
	camera.move(to_position, duration, target)

func switch_cam(c: int) -> void:
	var cam_arr_size: int = get_tree().get_nodes_in_group("cameras").size()
	for cam: int in cam_arr_size:
		cams_arr[cam].current = false
	cams_arr[c].current = true

func cue_lighting(l: int) -> void:
	var lights_arr_size: int = get_tree().get_nodes_in_group("stage_light").size()
	for light: int in lights_arr_size:
		lights_arr[light].hide()
	lights_arr[l].show()

#func narrate(text: String, position: Vector3, size_font: int, color: Color, clear_retained: bool) -> void:
	#var narrate_text: Label3D = NARRATIVE_TEXT.instantiate()
	#if clear_retained:
		#for child: int in text_layer.get_child_count():
			#if child != line_index:
				#text_layer.get_child(child).hide()
	#text_layer.add_child(narrate_text)
	#narrate_text.name = "Line_" + str(line_index)
	#narrate_text.text = text
	#narrate_text.font_size = size_font
	#narrate_text.modulate = color
	#narrate_text.global_position = position
