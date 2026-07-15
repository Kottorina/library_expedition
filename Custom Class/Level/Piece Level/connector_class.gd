extends Resource
class_name piece_connector

@export var coord_ : Vector2i
@export var size_ : int ##Соответвенно одна клетка, две, и три
@export_enum("down","up","left","right") var direction : String
@export_enum("room","corridor","enter_coridors") var type : int ##Для комнат,соединения коридоров,входов в корридоры
