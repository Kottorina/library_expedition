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


var save_data_all_library : SaveDataAllLibrary = null ## СЕЙВ ДАТА, АККУРАТНЕЕ БЛЯДИ

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

func UpdateAllSaveData(new_save_data : SaveDataAllLibrary) -> void: ## Обновляет save_data_all_library
	save_data_all_library = new_save_data
	
	ui_manager.UpdateUi(type_item.selected,editor_obj_layers, save_data_all_library)
	UpdateIdList()

func UpdateIdList() -> void: ## Обновляет список достпных id
	if save_data_all_library == null:
		return
	
	id_item.clear()
	
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var object_ar : Array = save_data_all_library.GetArFromKey(cur_editor_obj_layers.data_key)
	if object_ar == null:
		return
	
	for object in object_ar:
		var name_item = str(object.name_," ",object.id_)
		id_item.add_item(name_item,object.id_)
	
	if id_item.item_count == 0:
		_on_add_new_button_pressed()

func _on_add_new_button_pressed() -> void: ## Добовляет новый ресурс
	
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var new_obj = save_data_all_library.AddNewObjInArray(cur_editor_obj_layers.data_key)
	UpdateIdList()
	LoadGraphObj(new_obj)
 
@warning_ignore("unused_parameter")
func _on_type_item_item_selected(index: int) -> void: ## ПРИ выборе ТЕКУЩЕГО Глобального типа редактора, для смены ui везде
	
	ui_manager.UpdateUi(type_item.selected,editor_obj_layers, save_data_all_library)
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
	
	var cur_oject = save_data_all_library.GetObjectFromId(cur_editor_obj_layers.data_key,cur_id)
	if cur_oject != null:
		LoadGraphObj(cur_oject)

func _on_save_button_pressed() -> void:
	SaveGraph()
	
## НЕ НУЖНА, ПОЧЕМУ ТО ОНО И ТАК СОХРАНЯЕТ АВТОМАТОМ PS - В ТЕЕКУЩЕМ ВИДЕ СОХРАНЯЕТ
func SaveGraph() -> void:
	print("save graph")
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var cur_oject = save_data_all_library.GetObjectFromId(cur_editor_obj_layers.data_key,cur_id)
	if cur_oject != null:
		save_node.SaveBakeGraph(cur_editor_obj_layers, cur_oject)
	
func _on_del_item_pressed() -> void:
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	save_data_all_library.DelItemFromId(cur_editor_obj_layers.data_key,cur_id)
	UpdateIdList()

func _on_rename_pressed() -> void:
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var cur_oject = save_data_all_library.GetObjectFromId(cur_editor_obj_layers.data_key,cur_id)
	cur_oject.name_ = item_name.text
	
	SaveGraph()
	UpdateIdList()
