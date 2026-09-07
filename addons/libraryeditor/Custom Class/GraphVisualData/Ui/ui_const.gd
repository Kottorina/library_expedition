extends Resource
class_name UiConstFunc

## Типы коннекторов
const TOOLTYPE : int = 5 ##Для передачи технических значений
const TOOLCOLOR :=  Color.WHITE

const TOOLENTERTYPE : int = 17
const TOOLENTERCOLOR : Color = Color.PURPLE

const TOOL_DIALOGUR_TYPE_CON : int = 18
const TOOL_DIALOGUE_COLOR_CON : Color = Color.RED

## КАТЕГОРИЯ ГРУППЫ
const TOOL_FORK_UI_NAME : String = "Tool Fork"
const TOOL_UI_NAME : String = "Tool"
const ROOMS_UI_NAME : String = "Rooms"
const DIALOGUE_UI_NAME : String = "Dialogue"

## ДЛЯ BIG_INSTR
const ROOM_BIG_TITLE = "Room Node: "
const ENTER_LOCATION_BIG_TITLE : String = "Enter Location Node"
const START_GENER_LOCATION_BIG_TITLE : String = "Start Gener Node"
const BIG_RND_FORK_BIG_TITLE : String = "Rnd Fork"
const CONNECTORS_PLUGS_BIG_TITLE : String = "Connectors Plugs Node"

const DIALOGUE_START_BIG_TITLE = "Dialogue Start"
const DIALOGUE_NODE_TITLE = "Dialogue Node"
const DIALOGUE_END_BIG_TITLE = "Dialogue End"

## ДЛЯ INSTR
const TOOL_TITLE : String = "Tool:"
const ENTER_LOCATION_TITLE : String = "Id Enter:"
const INSTR_FORK_BASE_TITLE : String = "Base Option: "
const INSTR_FORK_ALT_CHANCE_TITLE : String = "Alt Chance: "
const TOOL_CONNECTOR_TITLE : String = "Connector:"

const DIALOGUE_TITLE : String = "Dialogue: "

## ОСТАЛЬНЫЕ КОНСТАНТЫ: WHITE GRAY BLACK
const BASE_COLOR_TYPE : Array[String] = ["black","gray","white"]

const DIRECTION : Array[String] = ["up","down","left","right"] 
var TOOL_CONNECTOR_DIRECTION_AR : Array[Array] = [[true,false],[false,true],[true,false],[false,true]]

const SIZE : Array[String] = ["tiny","small","medium","large"]

const CONNECTORTYPEDICT : Dictionary = {
0 : [5,6,7,8],
1 : [9,10,11,12],
2 : [13,14,15,16]
}
var CONNECTORCOLORDICT : Dictionary = {
0 : [Color.LIGHT_BLUE,Color.BLUE,Color.DARK_BLUE,Color.SLATE_BLUE],
1 : [Color.LIGHT_YELLOW,Color.YELLOW,Color.DARK_KHAKI,Color.DARK_GOLDENROD],
2 : [Color.LIGHT_CORAL,Color.RED,Color.DARK_RED,Color.DARK_MAGENTA],
3 : [Color.LIGHT_GREEN,Color.GREEN,Color.DARK_GREEN,Color.DARK_SLATE_GRAY]
}

## МИНИ ИНСТРУКЦИЯ ДЛЯ TOOL
func get_tool_instr() -> GraphNodeMakeInsts:
	
	var tool_instr = GraphNodeMakeInsts.new()
	tool_instr.title_instr = TOOL_TITLE
	
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

func get_dialogue_instr() -> GraphNodeMakeInsts:
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = 2
	instr.title_instr = DIALOGUE_TITLE
	
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
