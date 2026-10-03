extends VBoxContainer

var path_node_const := PathNodeConst.new()

@export var gener_rule_editor : Node
@export var type_data : OptionButton

@export var add_data_path_but : Button

@export var path_cont : Container

@export var file_save_load : Control ## ДЛЯ СОХРАНЕНИЯ ПУТЕЙ

const FileDialogueUseNative = true
const FIleDialogueAcess = FileDialog.ACCESS_FILESYSTEM

func _ready() -> void:
	UpdateBaseUi()
	add_data_path_but.pressed.connect(AddDataPathButPressed)
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
	
	var path_node = path_obj_layers[type_data.selected].duplicate(true)
	
	var le_file_system : LeFileSystem = file_save_load.GetActualEditSave()
	if le_file_system == null:
		return
	
	le_file_system.AddNewObjInArray(path_node_const.PathObjData,path_node)
	MakePathUi(path_node)

func DelAllPathUi() -> void:
	for child in path_cont.get_children():
		child.queue_free()
func DelAllPathData() -> void:
	var le_file_system : LeFileSystem = file_save_load.GetActualEditSave()
	if le_file_system == null:
		return
	for category in path_node_const.AllNameArray:
		le_file_system.ClearCategory(category)


func LoadSavePath( le_file_system : LeFileSystem) -> void:
	
	DelAllPathUi()
	DelAllPathData()
	
	var path_node_ar = le_file_system.GetArFromKey(path_node_const.PathObjData)
	for path_node : PathNode in path_node_ar:

		MakePathUi(path_node)
		#LoadPath(path_node)

@export var path_scene : PackedScene
func MakePathUi( path_node : PathNode) -> void:
	var path_ui_scene = path_scene.instantiate()
	path_ui_scene.MakeUi(path_node, self)
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
	
	if path_node.path_data == null:
		push_warning("path_data Is Null!!! in PathManageer")
		return
	
	var bake_path_set : BakePathSet
	
	var baker_class = path_node.baker_object_script_path
	if baker_class != null:
		var ready_baker : BakerMain = baker_class.new()
		bake_path_set = ready_baker.BakePathData(path_node.path_data, path_node.data_key)
		if bake_path_set == null:
			push_warning("bake_path_set Id Null!")
			return
	else:
		push_warning("Baker for "+ path_node.data_key+" not find!")
		return
	
	var le_file_system : LeFileSystem = file_save_load.GetActualEditSave()
	if le_file_system == null:
		return
	
	le_file_system.DelItemFromId(bake_path_set.ui_category,path_node.id_)
	
	le_file_system.AddNewObjInArray(bake_path_set.ui_category,bake_path_set.path_library_object,path_node.id_)

func DelPath(path_node : PathNode) -> void:
	
	var ui_category : String
	
	var baker_class = path_node.baker_object_script_path
	if baker_class != null:
		ui_category = path_node.data_key
	else:
		push_warning("Baker for "+ path_node.data_key+" not find!")
		return
		
	var le_file_system : LeFileSystem = file_save_load.GetActualEditSave()
	if le_file_system == null:
		return
	
	le_file_system.DelItemFromId(ui_category,path_node.id_)
	le_file_system.DelItemFromId(path_node_const.PathObjData,path_node.id_)
