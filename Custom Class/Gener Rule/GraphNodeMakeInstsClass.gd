extends Resource
class_name GraphNodeMakeInsts

@export var title_instr : String = "Null"

@export var is_left : bool = false
@export var left_type : int = 0
@export var left_color : Color = Color.BLACK

@export var is_right : bool = false
@export var right_type : int = 0
@export var right_color : Color = Color.BLACK

@export_enum("label","spin_box") var body_node : int = 0 ##"label","spin_box"
