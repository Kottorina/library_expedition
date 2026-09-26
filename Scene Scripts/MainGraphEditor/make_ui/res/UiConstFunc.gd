extends UiConst
class_name UiConstFunc

const BODY_NODE = GraphNodeMakeInsts.BodyNode

func GetOpenToolInstr() -> GraphNodeMakeInsts:
	
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.Label_
	instr.title_instr = TOOL_TITLE
	
	OpenInstr(instr,TOOL_TYPE,TOOL_COLOR)
	
	return instr

func GetOpenEnterInstr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.SpinBox_
	instr.title_instr = ENTER_LOCATION_TITLE
	
	OpenInstr(instr,TOOL_ENTER_TYPE,TOOL_ENTER_COLOR)
	
	return instr

func GetCloseDialogueInstr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.TextEdit_
	instr.title_instr = DIALOGUE_TITLE
	return instr

func GetCloseDialogueCharacterInstr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.TextEdit_
	instr.title_instr = DIALOGUE_CHARACTER_TITLE
	return instr

func GetOpenDialogueConnectorInstr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.Label_
	instr.title_instr = DIALOGUE_CON_TITLE
	
	OpenInstr(instr, TOOL_DIALOGUR_TYPE_CON, TOOL_DIALOGUE_COLOR_CON)
	
	return instr

func GetOpenDialogueChoiseInstr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.TextEdit_
	instr.title_instr = DIALOGUE_CHOISE_TITLE
	
	OpenInstr(instr, TOOL_DIALOGUR_TYPE_CON, TOOL_DIALOGUE_COLOR_CON)
	
	return instr

func GetCloseAudioData() -> GraphNodeMakeInsts:
	
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.Label_
	instr.title_instr = AUDIO_DATA_TITLE
	
	return instr

func GetOpenAudioConnector() -> GraphNodeMakeInsts:
	
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = BODY_NODE.Label_
	instr.title_instr = AUDIO_CON_TITLE
	
	OpenInstr(instr,TOOL_AUDIO_TYPE_CON,TOOL_AUDIO_COLOR_CON)
	
	return instr

func OpenInstr(instr : GraphNodeMakeInsts, type : int, color : Color) -> void:
	
	instr.is_right = true
	instr.right_type = type
	instr.right_color = color
	instr.is_left = true
	instr.left_type = type
	instr.left_color = color

#func get_inst_from_connector(connector : RoomConnector ) -> GraphNodeMakeInsts:
	#var instr := GraphNodeMakeInsts.new()
#
	#instr.body_node = 0
	#instr.source_res = connector
	#instr.title_instr = " ".join([TOOL_CONNECTOR_TITLE, DIRECTION[connector.direction], BASE_COLOR_TYPE[connector.type], SIZE[connector.size_]])
	#
	#instr.is_left = TOOL_CONNECTOR_DIRECTION_AR[connector.direction][0]
	#instr.is_right = TOOL_CONNECTOR_DIRECTION_AR[connector.direction][1]
	#instr.left_type = CONNECTORTYPEDICT[connector.type][connector.size_]
	#instr.right_type = CONNECTORTYPEDICT[connector.type][connector.size_]
	#instr.left_color = CONNECTORCOLORDICT[connector.type][connector.size_]
	#instr.right_color = CONNECTORCOLORDICT[connector.type][connector.size_]
	#
	#return instr

#func room_to_big_instr_graphnode(room : Room) -> BigGraphNodeMakeInsts:
	#var big_instr = BigGraphNodeMakeInsts.new()
	#big_instr.room_ = room
	#
	#for connector : RoomConnector in room.room_connectors_ar:
#
		#big_instr.instr_ar.append(get_inst_from_connector(connector))
	#for enter : RoomEnter in room.room_enter_ar:
		#
		#var instr = get_tool_enter_instr()
		#instr.body_node = 0
		#instr.source_res = enter
		#instr.title_instr = " ".join([ENTER_LOCATION_TITLE, BASE_COLOR_TYPE[enter.type]]) 
		#big_instr.instr_ar.append(instr)
	#
	#return big_instr
