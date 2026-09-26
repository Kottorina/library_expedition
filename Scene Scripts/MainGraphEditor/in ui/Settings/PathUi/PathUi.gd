extends Container

@export var data_key_lab : Label
@export var path_lab : Label

@export var new_path_but : Button
@export var load_but : Button

@export var del_but : Button
func _ready() -> void:
	new_path_but.pressed.connect(NewPath)
	load_but.pressed.connect(LoadPath)
	
	del_but.pressed.connect(queue_free)

@export var cur_path_node : PathNode 
@export var path_manager : Node ## РОДИТЕЛЬСКИЙ НОД ДЛЯ ЗАГРУЗКИ И ТД

func MakeUi(path_node : PathNode, path_manager_) -> void:
	cur_path_node = path_node
	path_manager = path_manager_
	UpdateUi()

func UpdateUi() -> void:
	data_key_lab.text = cur_path_node.data_key
	if cur_path_node.path_data != null:
		path_lab.text = cur_path_node.path_data

func NewPath() -> void:
	var path = await path_manager.NewPath(cur_path_node.file_mode)
	print("Path Change")
	cur_path_node.path_data = path
	
	LoadPath()
	UpdateUi()

func LoadPath() -> void:
	path_manager.LoadPath(cur_path_node)
