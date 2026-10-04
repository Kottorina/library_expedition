extends Node

var ui_const_func := UiConstFunc.new()

var le_file_system : LeFileSystem

const NODE_TYPE = BigGraphNodeMakeInsts.NodeType
const BODY_NODE = GraphNodeMakeInsts.BodyNode

func bake_ui_audio_start() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.AUDIO_START_BIG_TITLE
	big_instr.type_node = NODE_TYPE.START_AUDIO
	
	var tool_instr = ui_const_func.GetOpenToolInstr()
	tool_instr.body_node = BODY_NODE.TextEdit_
	big_instr.instr_ar.append(tool_instr)
	
	big_instr.instr_ar.append(ui_const_func.GetOpenAudioConnector())
	
	return [ui_const_func.AUDIO_UI_NAME, big_instr]

func bake_ui_audio_timer() -> Array:
	
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.AUDIO_TIMER_BIG_TITLE
	big_instr.type_node = NODE_TYPE.AUDIO_TIMER
	
	big_instr.instr_ar.append(ui_const_func.GetOpenAudioConnector())
	
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.SpinBox_
	instr.title_instr = ui_const_func.AUDIO_TIMER_TITLE
	
	big_instr.instr_ar.append(instr)
	
	return [ui_const_func.AUDIO_UI_NAME, big_instr]

func bake_ui_audio_end() -> Array:
	
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.AUDIO_END_BIG_TITLE
	big_instr.type_node = NODE_TYPE.AUDIO_END
	
	big_instr.instr_ar.append(ui_const_func.GetOpenAudioConnector())
	
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.SpinBox_
	instr.title_instr = ui_const_func.AUDIO_TIMER_TITLE
	
	big_instr.instr_ar.append(instr)
	
	return [ui_const_func.AUDIO_UI_NAME, big_instr]
	
func bake_ui_audio_crossroad_2() -> Array:
	var big_instr = get_crossroad(2)
	return [ui_const_func.AUDIO_UI_NAME, big_instr]
func bake_ui_audio_crossroad_4() -> Array:
	var big_instr = get_crossroad(4)
	return [ui_const_func.AUDIO_UI_NAME, big_instr]
func bake_ui_audio_crossroad_6() -> Array:
	var big_instr = get_crossroad(6)
	return [ui_const_func.AUDIO_UI_NAME, big_instr]
	
func get_crossroad( num_choise : int ) -> BigGraphNodeMakeInsts:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = " ".join([ui_const_func.AUDIO_CROSSROAD_BIG_TITLE,str(num_choise)])  
	big_instr.type_node = NODE_TYPE.AUDIO_CROSSROAD
	
	for i in num_choise:
		big_instr.instr_ar.append(ui_const_func.GetOpenAudioConnector())
	
	return big_instr

func bake_ui_audio_setting_loop() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.AUDIO_LOOP_SETTING_BIG_INSTR
	big_instr.type_node = NODE_TYPE.AUDIO_SETTING_LOOP
	
	big_instr.instr_ar.append(ui_const_func.GetOpenAudioConnector())
	
	var tool_instr = ui_const_func.GetCloseAudioData()
	tool_instr.body_node = BODY_NODE.CheckBox_
	tool_instr.title_instr = UiConst.AUDIO_LOOP_SETTING_TITlE
	big_instr.instr_ar.append(tool_instr)
	
	return [ui_const_func.AUDIO_UI_NAME, big_instr]
	
