extends ColorRect

signal custom_signal(foo)

func _ready() -> void:
	connect("hide", self, "_on_hide")

func _on_ColorRect_mouse_entered() -> void:
	pass # Replace with function body.


func _on_hide() -> void:
	pass
