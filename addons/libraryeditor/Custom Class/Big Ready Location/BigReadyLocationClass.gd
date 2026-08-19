extends Resource
class_name BigReadyLocation

@export var id_ : int 
@export var name_ : String

@export var save_graph : Dictionary ## {Big_instr : { right / left ports : [ port_metadata :  String free/occupied/new BigInstr ] } }
## ГРАФ СОДЕРЖАЩИЙ ВСЕ СОЕДИНЕНИЯ
 
@export var ui : SceneGraphUi
