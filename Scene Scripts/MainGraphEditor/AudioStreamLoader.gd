extends HBoxContainer

@export var file_dialog_folder_popup: FileDialog

func _ready() -> void:
	file_dialog_folder_popup.dir_selected.connect(load_path_folder)

func load_path_folder(val ) -> void:
	print(val)
