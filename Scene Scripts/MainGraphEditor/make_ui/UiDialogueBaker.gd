extends Node

var ui_const_func := UiConstFunc.new()

var cur_editor_obj_layer_ar : Array[EditorObjectLayer]
var cur_save_data_all_library : SaveDataAllLibrary

const START_DIALOGUE := 9
const DIALOGUE_CHOICE := 12
const DIALOGUE_CONNECTOR := 13
const DIALOGUE_SETTING := 14

func bake_ui_dialogue_start() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_START_BIG_TITLE
	big_instr.type_node = START_DIALOGUE
	
	var tool_instr = ui_const_func.get_tool_instr()
	tool_instr.body_node = 2
	big_instr.instr_ar.append(tool_instr)
	
	big_instr.instr_ar.append(ui_const_func.get_dialogue_connector_instr())
	
	return [ui_const_func.DIALOGUE_UI_NAME, big_instr]

const DIALOGUE_NODE := 10
func bake_ui_dialogue_node() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_NODE_TITLE
	big_instr.type_node = DIALOGUE_NODE
	
	big_instr.instr_ar.append(ui_const_func.get_dialogue_character_instr())
	big_instr.instr_ar.append(ui_const_func.get_dialogue_instr())
	big_instr.instr_ar.append(ui_const_func.get_dialogue_connector_instr())
	
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]

const END_DIALOGUE := 11
func bake_ui_dialogue_end() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_END_BIG_TITLE
	big_instr.type_node = END_DIALOGUE
	
	var tool_instr = ui_const_func.get_tool_instr()
	tool_instr.body_node = 2
	big_instr.instr_ar.append(tool_instr)
	
	big_instr.instr_ar.append(ui_const_func.get_dialogue_connector_instr())
	
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]

func bake_ui_dialogue_choice_2() -> Array:
	var big_instr = get_dialogue_choise(2)
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]
func bake_ui_dialogue_choice_3() -> Array:
	var big_instr = get_dialogue_choise(3)
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]
func bake_ui_dialogue_choice_4() -> Array:
	var big_instr = get_dialogue_choise(4)
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]

func get_dialogue_choise( num_choise : int ) -> BigGraphNodeMakeInsts:
	
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_CHOISE_BIG_TITLE + str(num_choise)
	big_instr.type_node = DIALOGUE_CHOICE
	
	var dialogue_instr = ui_const_func.get_dialogue_instr()
	dialogue_instr.body_node = 2
	dialogue_instr.title_instr = ui_const_func.DIALOGUE_CHOISE_TITLE
	dialogue_instr = ui_const_func.open_all_ports(dialogue_instr)
	big_instr.instr_ar.append(dialogue_instr)
	for i in num_choise:
		var instr = ui_const_func.get_dialogue_instr()
		instr = ui_const_func.open_all_ports(instr)
		big_instr.instr_ar.append(instr)
	
	return big_instr
#
func bake_ui_dialogue_con_2() -> Array:
	var big_instr = get_dialogue_con(2)
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]
func bake_ui_dialogue_con_4() -> Array:
	var big_instr = get_dialogue_con(4)
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]
func bake_ui_dialogue_con_6() -> Array:
	var big_instr = get_dialogue_con(6)
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]

func get_dialogue_con(num_con : int) -> BigGraphNodeMakeInsts:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_CONNETOR_BIG_TITLE + str(num_con)
	big_instr.type_node = DIALOGUE_CONNECTOR
	
	for i in num_con:
		var instr = ui_const_func.get_dialogue_connector_instr()
		big_instr.instr_ar.append(instr)
	
	return big_instr

func bake_ui_dialogue_setting() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_SETTING_BIG_TITLE
	big_instr.type_node = DIALOGUE_SETTING
	
	big_instr.instr_ar.append(ui_const_func.get_dialogue_connector_instr())
	
	var instr_skip = GraphNodeMakeInsts.new()
	instr_skip.body_node = 3
	instr_skip.title_instr = ui_const_func.DIALOGUE_IS_SKIPED_TITLE
	big_instr.instr_ar.append(instr_skip)
	
	var instr_0 = GraphNodeMakeInsts.new()
	instr_0.body_node = 1
	instr_0.title_instr = ui_const_func.DIALOGUE_BEFOR_TIME_TITLE
	big_instr.instr_ar.append(instr_0)
	
	var instr_1 = GraphNodeMakeInsts.new()
	instr_1.body_node = 1
	instr_1.title_instr = ui_const_func.DIALOGUE_AFTER_TIME_TITLE
	big_instr.instr_ar.append(instr_1)
	
	var instr_2 = GraphNodeMakeInsts.new()
	instr_2.body_node = 1
	instr_2.title_instr = ui_const_func.DIALOGUE_CHAR_TIME_TITLE
	big_instr.instr_ar.append(instr_2)
	
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]
