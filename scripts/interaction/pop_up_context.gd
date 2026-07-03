extends Area3D
class_name PopUpContextArea

@onready var context_pop_up: PanelContainer = %ContextPopUp
@export var pop_up_text: String
@onready var total_text_length: int = pop_up_text.length()
@onready var t: int = total_text_length
@export var anim: AnimatedSprite3D = null
var line_break_count: int = 1
var mouse_hover: bool = false

func _process(_delta: float) -> void:
	if !mouse_hover:
		if anim:
			anim.hide()
			anim.stop()
		return
	_text_wrap()
	if line_break_count == 1:
		context_pop_up.size = Vector2((total_text_length * 8) + 32, 32)
	else:
		context_pop_up.size = Vector2((total_text_length * 8) + 32, 32 * line_break_count)
	context_pop_up.get_child(0).text = pop_up_text
	context_pop_up.show()
	context_pop_up.global_position = get_viewport().get_mouse_position()
	
	if !anim:
		return
	anim.show()
	anim.play() 
	
func _text_wrap() -> int:
	while t > 32:
		t -= 32
		line_break_count += 1
	return line_break_count

func _on_mouse_entered() -> void:
	mouse_hover = true

func _on_mouse_exited() -> void:
	mouse_hover = false
	context_pop_up.hide()
