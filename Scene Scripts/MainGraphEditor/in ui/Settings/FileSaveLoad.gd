extends BoxContainer

@export var editor_layer_manager: VBoxContainer
@export var path_manager : Control

@export var main_graph_editor: Node
@export var file_dialog_popup: FileDialog


var edditor_save_data : EditorSaveData = null
var cur_all_save_data : SaveDataAllLibrary = null

@export_category("Ui")
@export var name_ui_label : Label

func _ready() -> void:
	edditor_save_data = ResourceLoader.load( main_graph_editor.editor_save_data_path,"",ResourceLoader.CACHE_MODE_IGNORE )
	LoadFilePath(edditor_save_data.current_file_save_path)
	file_dialog_popup.file_selected.connect(LoadFilePath)

func NewPathPressed() -> void:
	file_dialog_popup.show()

func LoadFilePath( path : String = edditor_save_data.current_file_save_path) -> void:

	var load_node : Variant
	
	if FileAccess.file_exists(path):
		load_node = ResourceLoader.load( path,"",ResourceLoader.CACHE_MODE_IGNORE )
	
	if load_node is SaveDataAllLibrary:
		
		UpdateUi(path)
		LoadAllSaveData(load_node)
		
		edditor_save_data.current_file_save_path = path
		SaveSettingData() 
	else:
		push_warning("File Is Not SaveDataAllLibrary")

func UpdateUi(path : String) -> void:
	name_ui_label.text = path.get_file()
	name_ui_label.tooltip_text = path

## СОХРАНЯЕТ ФАЙЛ НАСТРОЕК EditorSaveData
func SaveSettingData() -> void:
	print("setting_data Save")
	ResourceSaver.save(edditor_save_data, main_graph_editor.editor_save_data_path) 

## ЗАГРУЖАЕТ ДАННЫЕ ВО ВНУТРЕННИЕ РЕДАКТОРЫ
func LoadAllSaveData( all_save_data : SaveDataAllLibrary) -> void:
	print("SaveDataAllLibrary Load")
	
	cur_all_save_data = all_save_data
	
	editor_layer_manager.UpdateAllSaveData(all_save_data)
	path_manager.LoadPathDictionary(all_save_data)

## СОХРАНЯЕТ ФАЙЛ ДАННЫХ SaveDataAllLibrary
func SaveEditData() -> void:
	print("SaveDataAllLibrary Save")
	if editor_layer_manager.save_data_all_library != null:
		## СОХРАНЯЕТ САМИ ДАНННЫЕ SaveDataAllLibrary
		ResourceSaver.save(editor_layer_manager.save_data_all_library,edditor_save_data.current_file_save_path)

func GetActualEditSave() -> Variant:
	if cur_all_save_data is SaveDataAllLibrary:
		return cur_all_save_data
	
	return null
