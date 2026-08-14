extends Resource
class_name ReadyLocation

@export var name_ : String

## ДЛЯ ОБРАБОТКИ ГРАФА И ДЛЯ НОРМАЛЬНОГО СОХРАНЕНИЯ А ТАКЖЕ ДЛЯ УДОБНОЙ ЗАГРУЗКИ
@export var save_graph : Dictionary ## {Big_instr : { right / left ports : [ port_metadata :  String free/occupied/new BigInstr ] } }
## ГРАФ СОДЕРЖАЩИЙ ВСЕ СОЕДИНЕНИЯ
@export var full_graph : Dictionary 

@export var rooms_graph : Dictionary ## Отдельно Граф С Комнатами и коннекторами между --- { Room : [ ConnectorToConnector ] }
@export var enters_location : Dictionary ## Сожерит в себе вход res и его id входа --- { RoomEnter : Int }

@export var connection_plugs_instr : BigGraphNodeMakeInsts 
