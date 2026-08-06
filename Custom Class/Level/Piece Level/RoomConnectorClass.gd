extends BaseTile
class_name RoomConnector

@export var size_ : int ##Сколько клеток по стронам от центра
@export_enum("up","down","left","right") var direction : int
@export_enum("black","white") var type : int ##Для комнат,соединения коридоров,входов в корридоры 
