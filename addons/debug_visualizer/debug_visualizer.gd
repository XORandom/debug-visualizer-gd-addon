@tool
extends EditorPlugin

const scripts_dir := "res://addons/debug_visualizer/"

func _enable_plugin() -> void:
	# Add autoloads here.
	add_autoload_singleton("DebuggerVusializer","res://addons/debug_visualizer/debug_visualizer_src/debugger_vusializer.tscn")
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	remove_autoload_singleton("DebuggerVusializer")
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

func _get_plugin_name():
	return "DebuggerVusializer"
