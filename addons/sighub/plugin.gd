tool
extends EditorPlugin

var dashboard: Node


func _enter_tree():
	self.add_autoload_singleton("Sighub","res://addons/sighub/sighub.gd")

	# Initialization of the plugin goes here.
	# Load the dock scene and instance it.
	dashboard = preload("res://addons/sighub/sighub_dashboard.tscn").instance()
	# Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dashboard)
	# Note that LEFT_UL means the left of the editor, upper-left dock.

func _exit_tree() -> void:
	self.remove_autoload_singleton("Sighub")

	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dashboard)
	# Erase the control from the memory.
	dashboard.free()
