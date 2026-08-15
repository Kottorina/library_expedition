extends Resource
class_name BigGraphNodeMakeInsts

@export var title_node : String = ""
@export var coord_ := Vector2(0,0)

@export_enum("make_room", "enter_location","start_gener","tool_crossroad","con_pl","rnd_fork","rool_rnd_fork_set",
"rool_rnd_deco_tile"
) var type_node : int ##make_room,enter_location,start_gener,tool_crossroad,con_pl,rnd_fork,rool_rnd_fork_set
@export var room_ : Room

@export var instr_ar : Array[GraphNodeMakeInsts]

@export var ui_category : String = "Custom" ## КАТЕГОРИЯ ПРИ ЗАПЕКАНИИ UI
