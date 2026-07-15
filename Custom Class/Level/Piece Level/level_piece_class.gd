extends Resource
class_name level_piece

@export var name_ : String #Имя при заходе в комнату и тд
@export var id : int 

@export var wall_floor_level : Array[piece_wall_floor]
@export var connectors_level : Array[piece_connector]

@export var min_max_coord : Vector4i
