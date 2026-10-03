extends Control

@export_group("main")

@export var gener_rule_editor : Node ## Главный нод, из него подтигиваються, пути
@export var load_graph_node : Node
@export var save_node : Node
@export var ui_manager : Node 

@export_group("ui")

@export var type_item : OptionButton
@export var id_item : OptionButton
@export var item_name : TextEdit


var le_file_system : LeFileSystem = null ## СЕЙВ ДАТА, АККУРАТНЕЕ БЛЯДИ

var editor_obj_layers : Array[EditorObjectLayer]

func _ready() -> void:
	UpdateBaseUi()

## Обновляет editor_obj_layers и делает ui в type_item
func UpdateBaseUi() -> void:  
	editor_obj_layers = gener_rule_editor.editor_obj_layers
	var ind = 0
	for obj in editor_obj_layers:
		type_item.add_item(obj.data_key,ind)
		ind += 1

func UpdateAllSaveData(new_le_file_system : LeFileSystem) -> void: ## Обновляет save_data_all_library
	le_file_system = new_le_file_system
	
	ui_manager.UpdateUi(type_item.selected,editor_obj_layers, le_file_system)
	UpdateIdList()

func UpdateIdList() -> void: ## Обновляет список достпных id
	if le_file_system == null:
		return
	
	id_item.clear()
	
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var object_ar : Array = le_file_system.GetArFromKey(cur_editor_obj_layers.data_key)
	if object_ar == null:
		return
	
	for object in object_ar:
		var name_item = str(object.name_," ",object.id_)
		id_item.add_item(name_item,object.id_)
	
	if id_item.item_count == 0:
		_on_add_new_button_pressed()

func _on_add_new_button_pressed() -> void: ## Добовляет новый ресурс
	
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var new_obj = le_file_system.AddNewObjInArray(cur_editor_obj_layers.data_key,GraphDataObjects.new())
	UpdateIdList()
	LoadGraphObj(new_obj)
 
@warning_ignore("unused_parameter")
func _on_type_item_item_selected(index: int) -> void: ## ПРИ выборе ТЕКУЩЕГО Глобального типа редактора, для смены ui везде
	
	ui_manager.UpdateUi(type_item.selected,editor_obj_layers, le_file_system)
	UpdateIdList()

func LoadGraphObj(object : Resource) -> void: ## для загрузки ReadyLocation BigReadyLocation
	LoadGraph(object.save_graph)
	LoadUi(object.ui)
	item_name.text = object.name_

func LoadGraph(graph : Dictionary) -> void:
	print("load graph")
	load_graph_node.LoadSaveGraph(graph)
func LoadUi( scene_graph_ui : SceneGraphUi) -> void:
	load_graph_node.LoadUiSet(scene_graph_ui)

func _on_load_button_pressed() -> void: ## Загружает ресурс по текущему id
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var cur_oject = le_file_system.GetObjectFromId(cur_editor_obj_layers.data_key,cur_id)
	if cur_oject != null:
		LoadGraphObj(cur_oject)

func _on_save_button_pressed() -> void:
	SaveGraph()
	
## НЕ НУЖНА, ПОЧЕМУ ТО ОНО И ТАК СОХРАНЯЕТ АВТОМАТОМ PS - В ТЕЕКУЩЕМ ВИДЕ СОХРАНЯЕТ
func SaveGraph() -> void:
	print("save graph")
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var cur_oject = le_file_system.GetObjectFromId(cur_editor_obj_layers.data_key,cur_id)
	if cur_oject != null:
		save_node.SaveBakeGraph(cur_editor_obj_layers, cur_oject)
	
func _on_del_item_pressed() -> void:
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	le_file_system.DelItemFromId(cur_editor_obj_layers.data_key,cur_id)
	UpdateIdList()

func _on_rename_pressed() -> void:
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var cur_oject = le_file_system.GetObjectFromId(cur_editor_obj_layers.data_key,cur_id)
	cur_oject.name_ = item_name.text
	
	SaveGraph()
	UpdateIdList()
