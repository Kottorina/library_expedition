extends Resource
class_name BigGraphNodeMakeInsts

@export var title_node : String = ""
@export_enum("make_room", "enter_location") var type_node : int ##"make_room", "enter_location
@export var room_ : Room

@export var instr_ar : Array[GraphNodeMakeInsts]
