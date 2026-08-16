extends HBoxContainer

@export var auto_room_update: CheckBox

func get_auto_room_update_state() -> bool:
	return auto_room_update.button_pressed
