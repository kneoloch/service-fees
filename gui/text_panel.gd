extends PanelContainer
class_name TextPanel

@onready var label: RichTextLabel = %RichTextLabel
@export var text_speed: float = 0.05
@export var story_script: StoryScript
var true_center: Vector2 
var center_pivot: Vector2
var tween: Tween

func _ready() -> void:
	hide()
	_reset_panel()

func _unhandled_input(event: InputEvent) -> void:
	if Story.paused:
		return
	
	if event.is_action_released("ui_accept"):
		_advance_script()
	
	match event.get_class():
		"InputEventMouseButton", "InputEventScreenTouch":
			if event.pressed and not event.is_echo():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						_advance_script()

func _advance_script() -> void:
	if Story.end:
		return
	if story_script.check_for_text():
		_animate_test_box()
	else:
		story_script.check_for_executable()

func _animate_test_box() -> void:
	_reset_panel()
	label.clear()
	label.add_text(story_script.get_line())
	if story_script.line == -1:
		hide()
	else:
		true_center = get_viewport_rect().size / 2
		center_pivot = get_rect().size / 2
		global_position = true_center - center_pivot + story_script.get_pos()
		show()
		
		## Typewriter animation
		if tween and tween.is_running():
			tween.kill()
		tween = create_tween()
		tween.tween_property(label, "visible_ratio", 1.0, text_speed * label.get_total_character_count())
		tween.tween_callback(set_process.bind(true))
	story_script.check_for_executable()

func _reset_panel() -> void:
	reset_size()
	custom_minimum_size = Vector2(200, 0)
	label.visible_ratio = 0.0
