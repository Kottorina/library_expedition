extends Resource
class_name GraphNodeMakeInsts

@export var title_instr : String = ""

@export var is_left : bool = false
@export var left_type : int = 0
@export var left_color : Color = Color.BLACK

@export var is_right : bool = false
@export var right_type : int = 0
@export var right_color : Color = Color.BLACK

enum BodyNode {Label_,SpinBox_,TextEdit_,CheckBox_}
@export var body_node : BodyNode = BodyNode.Label_
@export var body_value : Variant ## int, float, str и тд, все схавает

@export var path_to_data : PathToData

## PS НЕ СПРАШИВАЙ ЗАЧЕМ ОТДЕЛЬНО body_value и source_res, Я САМА НЕ ЕБУ
