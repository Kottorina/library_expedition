extends Resource
class_name ReadyLocation

@export var name_ : String

##Для сохранения и загрузки уровня. ДА ЭТО РЕШЕНИЕ ПИЗДЕЦ, ПОШЛИ НАХУЙ
@export var save_graph : Dictionary ## {Big_instr : { right / left ports : [ port_metadata :  String free/occupied/new BigInstr ] } }

@export var rooms_graph : Dictionary ## Отдельно Граф С Комнатами и коннекторами между --- { Room : [ ConnectorToConnector ] }
@export var enters_location : Dictionary ## Сожерит в себе коды для вхохода --- { id_enter : Global_room_coord }
