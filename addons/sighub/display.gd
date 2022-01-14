tool
extends Control

onready var _go: Button = $Button
onready var _display: Label = $Label

"""

Might want to also create a registry of all custom signals with unique Id's
?? withing a project, do signal names need to be globally unique ??


Then we will need less metadata in the Listeners/Emmiters dict since the custom signal data can be
looked up here.

custom signals
{
	"signal_b": {
		"defining_file": "res://auto_loads/events.gd"
	}
}


{
	"Node2d.gd": {
		"emits": [

			#  Events.emit_signal("signal_b", "Bob")
			{
				"name": "signal_b",
				"sig_type": "CUSTOM", # NODE_BUILT_IN | CUSTOM
				"emiting_method": "_on_button_a_pressed",
				"sig_defined": "res://autoloads/events.gd"  # null if NODE_BUILT_IN
			},
			{...}
		],
		"listens": [

			#  $"TheBox/Button A".connect("pressed", self, "_on_button_a_pressed")
			{
				"name": "pressed",
				"sig_type": "NODE_BUILT_IN", # NODE_BUILT_IN | CUSTOM
				"node": "TheBox/Button A", #
				"sig_defined": null  # null if NODE_BUILT_IN
			},

			#  Events.connect("signal_a", self, "_on_signal_a")
			{
				"name": "signal_a",
				"sig_type": "CUSTOM", # NODE_BUILT_IN | CUSTOM
				"node": null, # null if custom signal
				"sig_defined": "res://autoloads/events.gd"  # null if NODE_BUILT_IN
			},
		]
	}
}



"""

func _ready() -> void:
	print("_ready")
	_go.connect("pressed", self, "_on_go_pressed")

func _on_go_pressed() -> void:
	print("_on_go_pressed")

	var path = "res://"
	var scene_signals = _get_scene_defined_signals(path)
	print(scene_signals)
#	var script_created_signals = _get_script_defined_signals(path)
#	var script_used_signals = _get_script_used_signals(path)



func _get_gd_files(path):
	var files = Files.get_files_in_dir(path, ["gd"])

	for gd_file in files:
		print("gd file: " + gd_file)

func _get_scene_defined_signals(path: String) -> Dictionary:
	var signals = {}
	var scene_files = Files.get_files_in_dir(path, ["tscn"])
	for scene in scene_files:
		var loaded_scene: PackedScene = load(scene)
		var scene_instance: Node = loaded_scene.instance()


		var scene_state: SceneState = loaded_scene.get_state()
		if scene_state.get_connection_count():
			for signal_idx in range(0, scene_state.get_connection_count()):
				var target_node = scene_instance.get_node(scene_state.get_connection_source(signal_idx))
				var target_script: Script = target_node.get_script()
				signals[scene] = {
					"scene": scene,
					"index": signal_idx,
					"params": scene_state.get_connection_binds(signal_idx),
					"flags": scene_state.get_connection_flags(signal_idx),
					"method": scene_state.get_connection_method(signal_idx),
					"signal": scene_state.get_connection_signal(signal_idx),
					"source_node": scene_state.get_connection_source(signal_idx),
					"target_node": scene_state.get_connection_target(signal_idx),
					"target_script": target_script.get_path(),
				}
	return signals

func _get_script_defined_signals(path: String):
	var signals = []
	var script_files = Files.get_files_in_dir(path, ["gd"])
	for script_file in script_files:
		var loaded: GDScript = load(script_file)
		signals += loaded.get_script_signal_list()
		print(script_file)
		print(loaded.get_script_signal_list())
	return signals

func _get_script_used_signals(path: String):
	var regex = RegEx.new()
	regex.compile("(\\$?[\"|']?[\\w\\/\\s]+[\"|']?\\.)?connect\\s*\\(([^\\)]*)\\)")
	var signals = []
	var script_files = Files.get_files_in_dir(path, ["gd"])
	for script_file in script_files:
		var loaded: GDScript = load(script_file)
		print("++++++++++++++++++++++++++")
		print(loaded.source_code)
		print("--------------------------")
		for result in regex.search_all(loaded.source_code):
			print("USED))" + script_file)
			var instance = loaded.new()
#			print(instance.get_property_list())
			print(result.get_string())
	return signals


