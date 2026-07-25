extends Resource
class_name parameters_corridor

@export_group("corridor")
@export var corridors_piece_set : piece_set_corridors
@export var corridor_min_max_long : Vector2i
@export_range(0,10,1) var corridor_step_generate : int ##Сколько будет коридоров после конца генерации первого
@export_range(0,1,0.01) var corridor_chance_to_end : float 

@export_group("main corridor")
@export var main_corridor_count : int
@export var main_corridor_min_max_long : Vector2i
@export_range(0,10,1) var main_corridor_step_generate : int ##Сколько будет коридоров после конца генерации первого
@export_range(0,1,0.01) var main_corridor_chance_to_end : float 
