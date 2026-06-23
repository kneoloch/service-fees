extends RichTextLabel
class_name NarrativeText

@export var typewriter: bool = false
@export var text_speed: float = 0.03
#@export var max_width: float = 500.0
var tween: Tween

func _ready() -> void:
	custom_minimum_size = Vector2(200, 0)
	pivot_offset = size/2
	pivot_offset_ratio = Vector2(0.5, 0.5)
	
	## ANIMATION -- Typewriter
	if typewriter:
		visible_ratio = 0.0
		if tween and tween.is_running():
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "visible_ratio", 1.0, text_speed * self.get_total_character_count())
		tween.tween_callback(set_process.bind(true))

func say(s: String) -> void:
	text = s
