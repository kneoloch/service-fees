extends Node

@onready var starting_color: Color = self.material.get("albedo_color")

func _on_area_3d_mouse_entered() -> void:
	self.material.set("albedo_color", starting_color + Color(0.5, 0.5, 0.5))

func _on_area_3d_mouse_exited() -> void:
	self.material.set("albedo_color", starting_color)
