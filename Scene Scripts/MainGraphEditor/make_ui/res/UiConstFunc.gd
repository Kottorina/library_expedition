extends UiConst
class_name UiConstFunc

## МИНИ ИНСТРУКЦИЯ ДЛЯ TOOL
func GetOpenToolInstr() -> GraphNodeMakeInsts:
	
	var instr = GraphNodeMakeInsts.new()
	instr.title_instr = TOOL_TITLE
	
	OpenInstr(instr,TOOLTYPE,TOOLCOLOR)
	
	return instr

func OpenInstr(instr : GraphNodeMakeInsts, type : int, color : Color) -> void:
	
	instr.is_right = true
	instr.right_type = type
	instr.right_color = color
	instr.is_left = true
	instr.left_type = type
	instr.left_color = color

## МИНИ ИНСТРУКЦИЯ ДЛЯ ENTER
func get_tool_enter_instr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = 1
	instr.title_instr = ENTER_LOCATION_TITLE
	
	
	instr.is_right = true 
	instr.right_type = TOOLENTERTYPE
	instr.right_color = TOOLENTERCOLOR
	instr.is_left = true
	instr.left_type = TOOLENTERTYPE
	instr.left_color = TOOLENTERCOLOR
	
	return instr

func get_dialogue_instr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = 2
	instr.title_instr = DIALOGUE_TITLE
	return instr

func get_dialogue_character_instr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = 2
	instr.title_instr = DIALOGUE_CHARACTER_TITLE
	return instr

func get_dialogue_connector_instr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = 0
	instr.title_instr = DIALOGUE_CON_TITLE
	
	instr.is_right = true 
	instr.right_type = TOOL_DIALOGUR_TYPE_CON
	instr.right_color = TOOL_DIALOGUE_COLOR_CON
	instr.is_left = true
	instr.left_type = TOOL_DIALOGUR_TYPE_CON
	instr.left_color = TOOL_DIALOGUE_COLOR_CON
	
	return instr

func open_all_dialogue_ports(instr : GraphNodeMakeInsts) -> GraphNodeMakeInsts:
	
	instr.is_right = true 
	instr.right_type = TOOL_DIALOGUR_TYPE_CON
	instr.right_color = TOOL_DIALOGUE_COLOR_CON
	instr.is_left = true
	instr.left_type = TOOL_DIALOGUR_TYPE_CON
	instr.left_color = TOOL_DIALOGUE_COLOR_CON
	
	return instr

## ИНСТРУКЦИЯ ИЗ КОННЕКТОРА
func get_inst_from_connector(connector : RoomConnector ) -> GraphNodeMakeInsts:
	var instr := GraphNodeMakeInsts.new()

	instr.body_node = 0
	instr.source_res = connector
	instr.title_instr = " ".join([TOOL_CONNECTOR_TITLE, DIRECTION[connector.direction], BASE_COLOR_TYPE[connector.type], SIZE[connector.size_]])
	
	instr.is_left = TOOL_CONNECTOR_DIRECTION_AR[connector.direction][0]
	instr.is_right = TOOL_CONNECTOR_DIRECTION_AR[connector.direction][1]
	instr.left_type = CONNECTORTYPEDICT[connector.type][connector.size_]
	instr.right_type = CONNECTORTYPEDICT[connector.type][connector.size_]
	instr.left_color = CONNECTORCOLORDICT[connector.type][connector.size_]
	instr.right_color = CONNECTORCOLORDICT[connector.type][connector.size_]
	
	return instr

func room_to_big_instr_graphnode(room : Room) -> BigGraphNodeMakeInsts:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.room_ = room
	
	for connector : RoomConnector in room.room_connectors_ar:

		big_instr.instr_ar.append(get_inst_from_connector(connector))
	for enter : RoomEnter in room.room_enter_ar:
		
		var instr = get_tool_enter_instr()
		instr.body_node = 0
		instr.source_res = enter
		instr.title_instr = " ".join([ENTER_LOCATION_TITLE, BASE_COLOR_TYPE[enter.type]]) 
		big_instr.instr_ar.append(instr)
	
	return big_instr
