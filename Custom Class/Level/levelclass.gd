extends Resource
class_name level

@export var name_ : String

@export_group("Structure level")
@export var start_room : level_piece

@export_subgroup("Corridors")
@export var corridors_piece_set : piece_set_corridors
@export var corridor_min_max_long : Vector2i
@export_range(0,15,1) var corridor_step_generate : int ##Сколько будет коридоров после конца генерации первого
#Нужно больше тонких настроек, плюс настройка для выходного main коридора
