extends Node

@export var main_graph_editor : Node
@export var ui_node_baker : Node

## ДЛЯ ИТЕРАЦИИ ПО UI В EDITOR LAYER
var tasks_bool : Dictionary = {
"ui_start_gener_node" : "bake_ui_start_gener_node",
"ui_start_gener_empty_node": "bake_ui_start_gener_empty_node",
"ui_all_rnd_fork" : "bake_ui_all_rnd_fork",
"ui_custom_big_instr" : "bake_custom_big_instr",
"ui_connectors_plugs" : "bake_ui_connectors_plugs",
"ui_enter_node" : "bake_ui_enter_node",
"ui_rooms_nodes" : "bake_ui_rooms_nodes",
"ui_ready_location_nodes" : "bake_ui_ready_location_nodes",

"ui_dialogue_start" : "bake_ui_dialogue_start",
"ui_dialogue_node" : "bake_ui_dialogue_node",
"ui_dialogue_end" : "bake_ui_dialogue_end",

"ui_dialogue_choice_2" : "bake_ui_dialogue_choice_2",
"ui_dialogue_choice_3" : "bake_ui_dialogue_choice_3",
"ui_dialogue_choice_4" : "bake_ui_dialogue_choice_4",

"ui_crossroad_2" : "bake_ui_crossroad_2",
"ui_crossroad_4" : "bake_ui_crossroad_4",
"ui_crossroad_6" : "bake_ui_crossroad_6"

}



var tasks_string : Dictionary = {
"ui_editor_layer_nodes" : "bake_ui_editor_layer_nodes"
}

func UpdateUi(cur_editor_obj_layer_id : int ,editor_obj_layer_ar : Array[EditorObjectLayer],save_data_all_library : SaveDataAllLibrary) -> void:
	
	ui_node_baker.cur_editor_obj_layer_ar = editor_obj_layer_ar
	ui_node_baker.cur_save_data_all_library = save_data_all_library
	
	ui_node_baker.graph_node_ui.StartBakeUi() ## НУЖНО ДЛЯ ОЧИСТКИ И ТД
	## ХОРОШИЙ ВОПРОС КАК РАБОТАТЬ С room_set
	ui_node_baker.room_set = ResourceLoader.load(main_graph_editor.room_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
	
	var cur_editor_layer = editor_obj_layer_ar[cur_editor_obj_layer_id]
	
	for task in tasks_bool.keys():
		var is_true = cur_editor_layer.get(task)
		if is_true == true:
			var callable = Callable(ui_node_baker, tasks_bool[task])
			if callable.is_valid():
				callable.call()
	
	for task in tasks_string.keys():
		var new_data_task : String = cur_editor_layer.get(task)
		if not new_data_task.is_empty():
			var callable = Callable(ui_node_baker, tasks_string[task])
			if callable.is_valid():
				callable.call(new_data_task)
