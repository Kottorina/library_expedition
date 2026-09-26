extends VBoxContainer

@export var gener_rule_editor : Node
@export var type_data : OptionButton

@export var add_data_path_but : Button
@export var save_but : Button

@export var path_cont : Container

@export var file_save_load : Control ## ДЛЯ СОХРАНЕНИЯ ПУТЕЙ

const PathData : String = "PathData"

const FileDialogueUseNative = true
const FIleDialogueAcess = FileDialog.ACCESS_FILESYSTEM

func _ready() -> void:
	UpdateBaseUi()
	add_data_path_but.pressed.connect(AddDataPathButPressed)
	save_but.pressed.connect(SaveData)
## Обновляет path_obj_layers и делает ui в type_item
var path_obj_layers : Array[PathNode]
func UpdateBaseUi() -> void:  
	path_obj_layers = gener_rule_editor.path_obj_layer
	type_data.clear()
	var ind = 0
	for obj in path_obj_layers:
		type_data.add_item(obj.data_key,ind)
		ind += 1

func AddDataPathButPressed() -> void:
	MakePathUi(path_obj_layers[type_data.selected])

func SaveData() -> void:
	
	var all_save_data : SaveDataAllLibrary = file_save_load.GetActualEditSave()
	if all_save_data == null:
		return
	
	all_save_data.ClearCategory(PathData)
	
	for child in path_cont.get_children():
		print(child.cur_path_node)
		all_save_data.AddNewObjInArray(PathData,child.cur_path_node)
	
	file_save_load.SaveEditData()

func LoadPathDictionary( all_save_data : SaveDataAllLibrary) -> void:
	
	var path_node_ar = all_save_data.GetArFromKey(PathData)
	for path_node : PathNode in path_node_ar:
		# if path is ПРОВЕРКА НА ПУТЬ
		MakePathUi(path_node)
		# А ТАКЖЕ ЗАГРУЗКА И ЗАПЕКАНИЕ

@export var path_scene : PackedScene
func MakePathUi( path_node : PathNode) -> void:
	var path_ui_scene = path_scene.instantiate()
	path_ui_scene.MakeUi(path_node.duplicate(true), self)
	path_cont.add_child(path_ui_scene)

func NewPath(file_mode : FileDialog.FileMode) -> Variant:
	
	var file_dialogue := FileDialog.new()
	file_dialogue.file_mode = file_mode
	
	file_dialogue.dir_selected.connect(GetResultFromFileDialogueFunc)
	file_dialogue.file_selected.connect(GetResultFromFileDialogueFunc)
	file_dialogue.files_selected.connect(GetResultFromFileDialogueFunc)
	#file_dialogue.canceled.connect(GetResultFromFileDialogueFunc)
	
	file_dialogue.use_native_dialog = FileDialogueUseNative
	file_dialogue.access = FIleDialogueAcess
	
	add_child(file_dialogue)
	file_dialogue.show()
	
	
	var result = await GetResultFromFileDialogue
	file_dialogue.queue_free()
	
	return result

signal GetResultFromFileDialogue
func GetResultFromFileDialogueFunc( result : Variant ) -> void:
	GetResultFromFileDialogue.emit(result)

func LoadPath(path_node : PathNode):
	
	return ""
	
