extends Node2D

onready var color_rect = get_node("ColorRect")

func _ready() -> void:
	$"TheBox/Button A".connect("pressed", self, "_on_button_a_pressed")
	Events.connect("signal_a", self, "_on_signal_a")



func _on_signal_a():
	print("I received singanl_a")

func _on_button_a_pressed():
	Events.emit_signal("signal_b", "Bob")
