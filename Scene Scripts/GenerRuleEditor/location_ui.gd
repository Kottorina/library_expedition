extends Control

@export var gener_rule_editor : Control ## Главный нод, из него подтигиваються, пути и рисуються ноды 
@export var type_item : OptionButton
@export var id_item : OptionButton
@export var item_name : TextEdit
@export var save_node : Node
@export var add_node_ui : Node 

var save_data_all_library : SaveDataAllLibrary = null ## СЕЙВ ДАТА, АККУРАТНЕЕ БЛЯДИ

var editor_obj_layers : Array[EditorObjectLayer]

func _ready() -> void:
	update_ui()

func update_ui() -> void:  ## Обновляет editor_obj_layers и делает ui в type_item
	editor_obj_layers = gener_rule_editor.editor_obj_layers
	var ind = 0
	for obj in editor_obj_layers:
		type_item.add_item(obj.data_key,ind)
		ind += 1

func update_all_save_data(new_save_data : SaveDataAllLibrary) -> void: ## Обновляет save_data_all_library
	save_data_all_library = new_save_data.duplicate()
	
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	add_node_ui.update_ui(cur_editor_obj_layers, save_data_all_library)
	update_id_list()

func update_id_list() -> void: ## Обновляет список достпных id
	if save_data_all_library == null:
		return
	
	id_item.clear()
	
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var object_ar : Array = save_data_all_library.get_ar_from_key(cur_editor_obj_layers.data_key)
	if object_ar == null:
		return
	
	for object in object_ar:
		var name_item = str(object.name_," ",object.id_)
		id_item.add_item(name_item,object.id_)
	
	if id_item.item_count == 0:
		_on_add_new_button_pressed()

func _on_add_new_button_pressed() -> void: ## Добовляет новый ресурс
	
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var new_obj = save_data_all_library.add_new_obj_in_array(cur_editor_obj_layers.data_key)
	update_id_list()
	load_res_f(new_obj)
 
@warning_ignore("unused_parameter")
func _on_type_item_item_selected(index: int) -> void: ## ПРИ выборе ТЕКУЩЕГО Глобального типа редактора, для смены ui везде
	
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	add_node_ui.update_ui(cur_editor_obj_layers, save_data_all_library)
	update_id_list()

func load_res_f(object : Resource) -> void: ## для загрузки ReadyLocation BigReadyLocation
	load_graph(object.save_graph)
	load_ui(object.ui)
	item_name.text = object.name_

func load_graph(graph : Dictionary) -> void:
	print("load graph")
	gener_rule_editor.load_graph(graph)
func load_ui( scene_graph_ui : SceneGraphUi) -> void:
	gener_rule_editor.load_ui_set(scene_graph_ui)

func _on_load_button_pressed() -> void: ## Загружает ресурс по текущему id
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var cur_oject = save_data_all_library.get_object_from_id(cur_editor_obj_layers.data_key,cur_id)
	if cur_oject != null:
		load_res_f(cur_oject)

func _on_save_button_pressed() -> void:
	save_graph()
	
## НЕ НУЖНА, ПОЧЕМУ ТО ОНО И ТАК СОХРАНЯЕТ АВТОМАТОМ
func save_graph() -> void:
	print("save graph")
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var cur_oject = save_data_all_library.get_object_from_id(cur_editor_obj_layers.data_key,cur_id)
	if cur_oject != null:
		var cur_ar : Array = save_data_all_library.get_ar_from_key(cur_editor_obj_layers.data_key)
		var save_ind = cur_ar.find(cur_oject)
		print(save_node.save_and_bake_graph(cur_editor_obj_layers, cur_oject))
		#save_data_all_library.all_data[cur_editor_obj_layers.data_key][save_ind] = save_node.save_and_bake_graph(cur_editor_obj_layers, cur_oject)
	
func _on_del_item_pressed() -> void:
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	save_data_all_library.del_item_from_id(cur_editor_obj_layers.data_key,cur_id)
	update_id_list()

func _on_rename_pressed() -> void:
	
	var cur_id = id_item.get_selected_id()
	var cur_editor_obj_layers : EditorObjectLayer = editor_obj_layers[type_item.selected]
	
	var cur_oject = save_data_all_library.get_object_from_id(cur_editor_obj_layers.data_key,cur_id)
	cur_oject.name_ = item_name.text
	update_id_list()
