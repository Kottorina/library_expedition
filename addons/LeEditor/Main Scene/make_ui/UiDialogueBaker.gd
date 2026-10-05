extends Node

var ui_const_func := UiConstFunc.new()

var le_file_system : LeFileSystem

const NODE_TYPE = BigGraphNodeMakeInsts.NodeType
const BODY_NODE = GraphNodeMakeInsts.BodyNode

func bake_ui_dialogue_start() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_START_BIG_TITLE
	big_instr.type_node = NODE_TYPE.START_DIALOGUE
	
	var tool_instr = ui_const_func.GetOpenToolInstr()
	tool_instr.body_node = BODY_NODE.TextEdit_
	big_instr.instr_ar.append(tool_instr)
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	
	return [ui_const_func.DIALOGUE_UI_NAME, big_instr]

func bake_ui_dialogue_node() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_NODE_BIG_TITLE
	big_instr.type_node = NODE_TYPE.DIALOGUE_NODE
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	big_instr.instr_ar.append(ui_const_func.GetCloseDialogueCharacterInstr())
	big_instr.instr_ar.append(ui_const_func.GetCloseDialogueInstr())
	
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]


func bake_ui_dialogue_end() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_END_BIG_TITLE
	big_instr.type_node = NODE_TYPE.END_DIALOGUE
	
	var tool_instr = ui_const_func.GetOpenToolInstr()
	tool_instr.body_node = BODY_NODE.TextEdit_
	big_instr.instr_ar.append(tool_instr)
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	
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
	big_instr.type_node = NODE_TYPE.DIALOGUE_CHOISE
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	big_instr.instr_ar.append(ui_const_func.GetCloseDialogueCharacterInstr())
	big_instr.instr_ar.append(ui_const_func.GetCloseDialogueInstr())
	
	for i in num_choise:
		big_instr.instr_ar.append(ui_const_func.GetOpenDialogueChoiseInstr())
	
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
	big_instr.type_node = NODE_TYPE.DIALOGUE_CON
	
	for i in num_con:
		big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	
	return big_instr

func bake_ui_dialogue_setting() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_SETTING_BIG_TITLE
	big_instr.type_node = NODE_TYPE.DIALOGUE_SETTING
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	
	var instr_skip = GraphNodeMakeInsts.new()
	instr_skip.body_node = BODY_NODE.CheckBox_
	instr_skip.title_instr = ui_const_func.DIALOGUE_IS_SKIPED_TITLE
	big_instr.instr_ar.append(instr_skip)
	
	var instr_0 = GraphNodeMakeInsts.new()
	instr_0.body_node = BODY_NODE.SpinBox_
	instr_0.title_instr = ui_const_func.DIALOGUE_BEFOR_TIME_TITLE
	big_instr.instr_ar.append(instr_0)
	
	var instr_2 = GraphNodeMakeInsts.new()
	instr_2.body_node = BODY_NODE.SpinBox_
	instr_2.title_instr = ui_const_func.DIALOGUE_BETWEEN_CHARACTER_TIME_TITLE
	big_instr.instr_ar.append(instr_2)
	
	var instr_1 = GraphNodeMakeInsts.new()
	instr_1.body_node = BODY_NODE.SpinBox_
	instr_1.title_instr = ui_const_func.DIALOGUE_AFTER_TIME_TITLE
	big_instr.instr_ar.append(instr_1)
	
	var instr_3 = GraphNodeMakeInsts.new()
	instr_3.body_node = BODY_NODE.SpinBox_
	instr_3.title_instr = ui_const_func.DIALOGUE_CHAR_CHARACTER_TIME_TITLE
	big_instr.instr_ar.append(instr_3)
	
	var instr_4 = GraphNodeMakeInsts.new()
	instr_4.body_node = BODY_NODE.SpinBox_
	instr_4.title_instr = ui_const_func.DIALOGUE_CHAR_LINE_TIME_TITLE
	big_instr.instr_ar.append(instr_4)
	
	
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]

func bake_ui_dialogue_emit_signal() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_EMIT_SIGNAL_BIG_TITLE
	big_instr.type_node = NODE_TYPE.DIALOGUE_EMIT_SIGNAL
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())

	var instr_0 = GraphNodeMakeInsts.new()
	instr_0.body_node = BODY_NODE.TextEdit_
	instr_0.title_instr = ui_const_func.EMIT_SIGNAL_TITLE
	big_instr.instr_ar.append(instr_0)
	
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]

func bake_ui_dialogue_await_signal() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_AWAIT_SIGNAL_BIG_TITLE
	big_instr.type_node = NODE_TYPE.DIALOGUE_AWAIT_SIGNAL
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	
	big_instr.instr_ar.append(ui_const_func.GetCloseDialogueInstr())
	
	var instr_0 = GraphNodeMakeInsts.new()
	instr_0.body_node = BODY_NODE.TextEdit_
	instr_0.title_instr = ui_const_func.AWAIT_SIGNAL_TITLE
	big_instr.instr_ar.append(instr_0)
	
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]

func bake_ui_dialogue_next_dialogue() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_NEXT_DIALOGUE_BIG_TITLE
	big_instr.type_node = NODE_TYPE.NEXT_DIALOGUE
	
	var tool_instr = ui_const_func.GetOpenToolInstr()
	tool_instr.body_node = BODY_NODE.TextEdit_
	big_instr.instr_ar.append(tool_instr)
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	
	return[ui_const_func.DIALOGUE_UI_NAME, big_instr]

func bake_ui_dialogue_to_tool() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.DIALOGUE_TO_TOOL_BIG_TITLE
	big_instr.type_node = NODE_TYPE.DILOGUE_TO_TOOl
	
	big_instr.instr_ar.append(ui_const_func.GetOpenDialogueConnectorInstr())
	big_instr.instr_ar.append(ui_const_func.GetOpenToolInstr())
	
	return [UiConst.DIALOGUE_UI_NAME, big_instr]
