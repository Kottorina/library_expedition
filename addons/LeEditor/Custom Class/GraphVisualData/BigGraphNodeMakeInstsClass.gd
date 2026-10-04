extends Resource
class_name BigGraphNodeMakeInsts

@export var title_node : String = ""
@export var coord_ := Vector2(0,0)

enum NodeType {

MAKE_ROOM, ENTER_LOCATION,

CON_PL,RND_FORK,ROOL_RND_FORK_SET,ROOL_RND_DECO_TILE,MAKE_LOCATION,

START_GENER,TOOL_CROSSROAD,

START_DIALOGUE,DIALOGUE_NODE,END_DIALOGUE,DIALOGUE_CHOISE,DIALOGUE_CON,
DIALOGUE_SETTING,DIALOGUE_EMIT_SIGNAL,DIALOGUE_AWAIT_SIGNAL,NEXT_DIALOGUE

,MAKE_AUDIO,START_AUDIO,AUDIO_TIMER,AUDIO_END,AUDIO_CROSSROAD,AUDIO_SETTING_LOOP,AUDIO_TO_TOOL

}

@export var type_node : NodeType 

@export var room_ : Room
@export var graph_data_object : GraphDataObjects

@export var instr_ar : Array[GraphNodeMakeInsts]

@export var ui_category : String = "Custom" ## КАТЕГОРИЯ ПРИ ЗАПЕКАНИИ UI
