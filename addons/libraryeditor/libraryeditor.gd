@tool
extends EditorPlugin

const PLUGIN_CFG := "res://addons/libraryeditor/plugin.cfg"

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass

func _enter_tree() -> void:
	var config := ConfigFile.new()
	var pl = config.load(PLUGIN_CFG)
	var version := config.get_value("plugin", "version", "")
	print(version)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
