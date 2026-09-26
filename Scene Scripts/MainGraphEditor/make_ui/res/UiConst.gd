extends Resource
class_name UiConst

## Типы коннекторов
const TOOLTYPE : int = 5 ##Для передачи технических значений
const TOOLCOLOR :=  Color.WHITE

const TOOLENTERTYPE : int = 17
const TOOLENTERCOLOR : Color = Color.PURPLE

const TOOL_DIALOGUR_TYPE_CON : int = 18
const TOOL_DIALOGUE_COLOR_CON : Color = Color.RED

const TOOL_AUDIO_TYPE_CON : int = 19
const TOOL_AUDIO_COLOR_CON : Color = Color.NAVY_BLUE

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
##//
const DIALOGUE_START_BIG_TITLE = "Dialogue Start"
const DIALOGUE_NODE_BIG_TITLE = "Dialogue Node"
const DIALOGUE_END_BIG_TITLE = "Dialogue End"
const DIALOGUE_CHOISE_BIG_TITLE = "Dialogue Choise: "
const DIALOGUE_CONNETOR_BIG_TITLE = "Dialogue Connector: "
const DIALOGUE_SETTING_BIG_TITLE = "Dialogue Setting: "
const DIALOGUE_EMIT_SIGNAL_BIG_TITLE = "Dialogue Emit Signal: "
const DIALOGUE_AWAIT_SIGNAL_BIG_TITLE = "Dialogue Await Signal: "
const DIALOGUE_NEXT_DIALOGUE_BIG_TITLE = "Next Dialogue: : "
##//
const AUDIO_STREAM_MP3_BIG_TITLE = "Audio Stream Mp3: "

## ДЛЯ INSTR
const TOOL_TITLE : String = "Tool:"
const ENTER_LOCATION_TITLE : String = "Id Enter:"
const INSTR_FORK_BASE_TITLE : String = "Base Option: "
const INSTR_FORK_ALT_CHANCE_TITLE : String = "Alt Chance: "
const TOOL_CONNECTOR_TITLE : String = "Connector:"

const EMIT_SIGNAL_TITLE : String = "Emit Signal: "
const AWAIT_SIGNAL_TITLE : String = "Await Signal: "

const MAKE_DIALOGUE : String = "Make Dialogue"
## //
const DIALOGUE_TITLE : String = "Dialogue: "
const DIALOGUE_CON_TITLE : String = "Dialogue Con: "
const DIALOGUE_CHARACTER_TITLE : String = "Dialogue Character: "

const DIALOGUE_CHOISE_TITLE : String = "Dialogue Choise: "

const DIALOGUE_IS_SKIPED_TITLE : String = "Is skiped: "
const DIALOGUE_BEFOR_TIME_TITLE : String = "Befor Time: "
const DIALOGUE_AFTER_TIME_TITLE : String = "After Time: "
const DIALOGUE_BETWEEN_CHARACTER_TIME_TITLE : String = "Between Character Line Time: "
const DIALOGUE_CHAR_CHARACTER_TIME_TITLE : String = "Char Character Time: "
const DIALOGUE_CHAR_LINE_TIME_TITLE : String = "Char Line Time: "
##//
#const 
const AUDIO_TITLE : String = "Audio: "

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

const DIRECTION_INVERT : Array[int] = [1,0,3,2] 
