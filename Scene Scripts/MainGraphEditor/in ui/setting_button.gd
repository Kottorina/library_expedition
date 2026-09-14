extends Button

@export var SettingPanel : PanelContainer

func _on_pressed() -> void:
	SettingPanel.visible = !SettingPanel.visible
