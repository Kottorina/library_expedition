@tool
extends EditorPlugin

const PLUGIN_CFG := "res://addons/LeFileSystem/plugin.cfg"

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	var config := ConfigFile.new()
	var pl = config.load(PLUGIN_CFG)
	var version_plugin := config.get_value("plugin", "version", "")
	var name_plugin := config.get_value("plugin", "name", "")
	var autor_plugin := config.get_value("plugin", "author", "")
	print(name_plugin,"/",version_plugin,"/",autor_plugin)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
