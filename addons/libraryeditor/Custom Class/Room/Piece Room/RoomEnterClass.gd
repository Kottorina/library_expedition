extends BaseTile
class_name RoomEnter

#@export var size_ : int ##Сколько клеток по стронам от центра
#@export_enum("up","down","left","right") var direction : int ## "up","down","left","right"
@export_enum("black","gray","white") var type : int ## "black","white" Для комнат,соединения коридоров,входов в корридоры 

func update_room_enter_data(new_enter : RoomEnter) -> void:
	type = new_enter.type
	atl_coord_ = new_enter.atl_coord_
	coord_ = new_enter.coord_
	deco_level = new_enter.deco_level
	id_ = new_enter.id_
