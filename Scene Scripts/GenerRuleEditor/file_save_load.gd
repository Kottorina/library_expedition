extends VBoxContainer

var edditor_save_data : EditorSaveData = null

@export var gener_rule_editor: Control
@export var file_dialog_popup: FileDialog

@export var name_ui_label : Label

const NameFile : String = "Name: "
const PathNameFile : String = "Path To File: "

func _ready() -> void:
	
	edditor_save_data = ResourceLoader.load( gener_rule_editor.editor_save_data_path,"",ResourceLoader.CACHE_MODE_IGNORE )
	load_file_path(edditor_save_data.current_file_save_path)

func _on_load_file_pressed() -> void:
	file_dialog_popup.show()

func load_file_path( path : String ) -> void:
	
	var load_node : Variant
	
	if FileAccess.file_exists(path):
		load_node = ResourceLoader.load( path,"",ResourceLoader.CACHE_MODE_IGNORE )
	
	if load_node is SaveDataAllLibrary:
		
		print("SaveDataAllLibrary Load")
		update_ui(path)
		
		edditor_save_data.current_file_save_path = path
		save_f() 
	else:
		push_warning("File Is Not SaveDataAllLibrary")

func update_ui(path : String) -> void:
	name_ui_label.text = NameFile + path.get_file()
	name_ui_label.tooltip_text = PathNameFile + path

func _on_file_dialog_file_selected(path: String) -> void:
	load_file_path(path)

func _on_save_file_pressed() -> void:
	print("SaveDataAllLibrary Save")
	save_f()

func save_f() -> void:
	ResourceSaver.save(edditor_save_data, gener_rule_editor.editor_save_data_path) 
