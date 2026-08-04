extends BaseTile
class_name RoomConnector

@export var size_ : int ##Сколько клеток по стронам от центра
@export_enum("down","up","left","right") var direction : int
@export_enum("room","corridor","enter_coridors") var type : int ##Для комнат,соединения коридоров,входов в корридоры
