extends Resource
class_name UiConstFunc

## Типы коннекторов
const TOOLTITLE : String = "Tool:"
const TOOLTYPE : int = 5 ##Для передачи технических значений
const TOOLCOLOR :=  Color.WHITE

const TOOLENTERTITLE : String = "Enter:"
const TOOLENTERTYPE : int = 17
const TOOLENTERCOLOR : Color = Color.PURPLE

## КАТЕГОРИЯ ГРУППЫ
const TOOL_FORK_UI_NAME : String = "Tool Fork"
const TOOL_UI_NAME : String = "Tool"
const ROOMS_UI_NAME : String = "Rooms"
const DIALOGUE_UI_NAME : String = "Dialogue"

## ДЛЯ INSTR
const ENTER_LOCATION_TITLE : String = "Id Enter:"
const INSTR_FORK_BASE_TITLE : String = "Base Option: "
const INSTR_FORK_ALT_CHANCE_TITLE : String = "Alt Chance: "
const TOOL_CONNECTOR_TITLE : String = "Connector:"

## ОСТАЛЬНЫЕ КОНСТАНТЫ
const DIRECTION : Array[String] = ["up","down","left","right"] 
const SIZE : Array[String] = ["tiny","small","medium","large"]

## МИНИ ИНСТРУКЦИЯ ДЛЯ TOOL
func get_tool_instr() -> GraphNodeMakeInsts:
	
	var tool_instr = GraphNodeMakeInsts.new()
	tool_instr.title_instr = TOOLTITLE
	
	tool_instr.is_right = true
	tool_instr.right_type = TOOLTYPE
	tool_instr.right_color = TOOLCOLOR
	tool_instr.is_left = true
	tool_instr.left_type = TOOLTYPE
	tool_instr.left_color = TOOLCOLOR
	
	return tool_instr

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

## ИНСТРУКЦИЯ ИЗ КОННЕКТОРА
func make_inst_from_connector(connector : RoomConnector ) -> GraphNodeMakeInsts:
	var instr := GraphNodeMakeInsts.new()

	instr.body_node = 0
	instr.source_res = connector
	instr.title_instr = " ".join([TOOL_CONNECTOR_TITLE, DIRECTION[connector.direction], BASECOLORTYPE[connector.type], SIZE[connector.size_]])
	
	instr.is_left = toolconnectordirection_ar[connector.direction][0]
	instr.is_right = toolconnectordirection_ar[connector.direction][1]
	instr.left_type = CONNECTORTYPEDICT[connector.type][connector.size_]
	instr.right_type = CONNECTORTYPEDICT[connector.type][connector.size_]
	instr.left_color = CONNECTORCOLORDICT[connector.type][connector.size_]
	instr.right_color = CONNECTORCOLORDICT[connector.type][connector.size_]
	
	return instr
