extends BaseTile
class_name RoomConnector

@export var size_ : int ##Сколько клеток по стронам от центра
@export_enum("up","down","left","right") var direction : int ## "up","down","left","right"
@export_enum("black","gray","white") var type : int ## "black","white" Для комнат,соединения коридоров,входов в корридоры 

func update_room_connector_data(new_connector : RoomConnector) -> void:
	direction = new_connector.direction
	size_ = new_connector.size_
	type = new_connector.type
	atl_coord_ = new_connector.atl_coord_
	coord_ = new_connector.coord_
	deco_level = new_connector.deco_level
	id_ = new_connector.id_
