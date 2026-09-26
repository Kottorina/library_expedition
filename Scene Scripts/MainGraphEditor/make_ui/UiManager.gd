extends Node

@export var graph_node_ui : Control

@export var main_graph_editor : Node

@export var ui_all_baker : Node
@export var ui_dialogue_baker : Node
@export var ui_audio_baker : Node

#"ui_all_rnd_fork" : ["ui_all_baker", "bake_ui_all_rnd_fork"],
#"ui_connectors_plugs" : ["ui_all_baker", "bake_ui_connectors_plugs"],
#"ui_enter_node" : ["ui_all_baker", "bake_ui_enter_node"],
#"ui_rooms_nodes" : ["ui_all_baker", "bake_ui_rooms_nodes"],
#"ui_ready_location_nodes" : ["ui_all_baker", "bake_ui_ready_location_nodes"],

## ДЛЯ ИТЕРАЦИИ ПО UI В EDITOR LAYER
var tasks_bool : Dictionary = {

"ui_start_gener_node" : ["ui_all_baker", "bake_ui_start_gener_node"],
"ui_start_gener_empty_node": ["ui_all_baker", "bake_ui_start_gener_empty_node"],

"ui_crossroad_2" : ["ui_all_baker", "bake_ui_crossroad_2"],
"ui_crossroad_4" : ["ui_all_baker", "bake_ui_crossroad_4"],
"ui_crossroad_6" : ["ui_all_baker", "bake_ui_crossroad_6"],

"ui_dialogue_start" : ["ui_dialogue_baker", "bake_ui_dialogue_start"],
"ui_dialogue_node" : ["ui_dialogue_baker", "bake_ui_dialogue_node"],
"ui_dialogue_end" : ["ui_dialogue_baker", "bake_ui_dialogue_end"],
"ui_dialogue_choice_2" : ["ui_dialogue_baker", "bake_ui_dialogue_choice_2"],
"ui_dialogue_choice_3" : ["ui_dialogue_baker", "bake_ui_dialogue_choice_3"],
"ui_dialogue_choice_4" : ["ui_dialogue_baker", "bake_ui_dialogue_choice_4"],
"ui_dialogue_con_2" : ["ui_dialogue_baker", "bake_ui_dialogue_con_2"],
"ui_dialogue_con_4" : ["ui_dialogue_baker", "bake_ui_dialogue_con_4"],
"ui_dialogue_con_6" : ["ui_dialogue_baker", "bake_ui_dialogue_con_6"],
"ui_dialogue_setting" : ["ui_dialogue_baker", "bake_ui_dialogue_setting"],
"ui_dialogue_emit_signal" : ["ui_dialogue_baker", "bake_ui_dialogue_emit_signal"],
"ui_dialogue_await_signal" : ["ui_dialogue_baker", "bake_ui_dialogue_await_signal"],
"ui_dialogue_next_dialogue" : ["ui_dialogue_baker", "bake_ui_dialogue_next_dialogue"],

"ui_audio_start" : ["ui_audio_baker","bake_ui_audio_start"],
"ui_audio_timer" : ["ui_audio_baker", "bake_ui_audio_timer"],
"ui_audio_end" : ["ui_audio_baker", "bake_ui_audio_end"],

"ui_audio_crossroad_2" : ["ui_audio_baker", "bake_ui_audio_crossroad_2"],
"ui_audio_crossroad_4" : ["ui_audio_baker", "bake_ui_audio_crossroad_4"],
"ui_audio_crossroad_6" : ["ui_audio_baker", "bake_ui_audio_crossroad_6"],
}

var tasks_ar_string : Dictionary = {
"ui_link_data_ar" : ["ui_all_baker", "bake_ui_link_data_ar"]
}

func UpdateUi(cur_editor_obj_layer_id : int ,editor_obj_layer_ar : Array[EditorObjectLayer],save_data_all_library : SaveDataAllLibrary) -> void:
	
	var ui_nodes : Dictionary = {
	"ui_all_baker" : ui_all_baker,
	"ui_dialogue_baker" : ui_dialogue_baker,
	"ui_audio_baker" : ui_audio_baker
	}

	for node in ui_nodes.values():
		#print(ui_nodes)
		node.cur_path_obj_layer_ar = main_graph_editor.path_obj_layer
		node.cur_editor_obj_layer_ar = editor_obj_layer_ar
		node.cur_save_data_all_library = save_data_all_library
	
	graph_node_ui.Clear() ## НУЖНО ДЛЯ ОЧИСТКИ И ТД

	var cur_editor_layer = editor_obj_layer_ar[cur_editor_obj_layer_id]
	
	for task in tasks_bool.keys():
		var is_true = cur_editor_layer.get(task)
		if is_true == true:
			var callable = Callable( ui_nodes[tasks_bool[task][0]], tasks_bool[task][1])
			if callable.is_valid():
				var data_ar : Array = callable.call()
				graph_node_ui.AddNewUiItem(data_ar[0],data_ar[1])
	
	for task in tasks_ar_string.keys():
		var new_data_task : Variant = cur_editor_layer.get(task)
		if not new_data_task.is_empty():
			var callable = Callable( ui_nodes[tasks_ar_string[task][0]], tasks_ar_string[task][1])
			if callable.is_valid():
				var data_ar : Array[BigGraphNodeMakeInsts] = callable.call(new_data_task)
				for big_instr in data_ar:
					graph_node_ui.AddNewUiItem(big_instr.ui_category,big_instr)
