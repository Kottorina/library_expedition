extends BoxContainer

@export var editor_layer_manager: VBoxContainer
@export var path_manager : Control

@export var new_path_but : Button

var edditor_save_data : EditorSaveData = null
var cur_le_file_system : LeFileSystem = null

@export_category("Ui")
@export var name_ui_label : Label

@export var setting_panel : Control

func _ready() -> void:
	await get_tree().process_frame
	
	setting_panel.visible = edditor_save_data.setting_panel_visible
	
	new_path_but.pressed.connect(NewPathPressed)
	LoadFilePath(edditor_save_data.current_file_save_path)

func NewPathPressed() -> void:
	var file_dial = FileDialog.new()
	file_dial.use_native_dialog = true
	file_dial.access = FileDialog.ACCESS_FILESYSTEM
	file_dial.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dial.file_selected.connect(LoadFilePath)
	file_dial.show()

func LoadFilePath( path : String = edditor_save_data.current_file_save_path) -> void:

	var load_node : Variant
	
	if FileAccess.file_exists(path):
		
		load_node = ResourceLoader.load( path,"",ResourceLoader.CACHE_MODE_IGNORE )
	
	if load_node is LeFileSystem:
		
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
	edditor_save_data.setting_panel_visible = setting_panel.visible
	print("setting_data Save")
	ResourceSaver.save(edditor_save_data) 

## ЗАГРУЖАЕТ ДАННЫЕ ВО ВНУТРЕННИЕ РЕДАКТОРЫ
func LoadAllSaveData( all_save_data : LeFileSystem) -> void:
	print("SaveDataAllLibrary Load")
	
	cur_le_file_system = all_save_data
	
	## СНАЧАЛА ЗАВИСИМОСТИ БЛЯДИ
	path_manager.LoadSavePath(all_save_data)
	
	editor_layer_manager.UpdateAllSaveData(all_save_data)
	
## СОХРАНЯЕТ ФАЙЛ ДАННЫХ LeFileSystem
func SaveEditData() -> void:
	
	SaveSettingData()
	
	print("LeFileSystem Save")
	if cur_le_file_system != null:
		## СОХРАНЯЕТ САМИ ДАНННЫЕ LeFileSystem
		ResourceSaver.save(cur_le_file_system,edditor_save_data.current_file_save_path)

func GetActualEditSave() -> Variant:
	if cur_le_file_system is LeFileSystem:
		return cur_le_file_system
	
	return null
