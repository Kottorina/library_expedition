@tool
extends Node

var collision_dict : Dictionary = {}

func make_collision(coord : Vector2i, piece : level_piece) -> void:
	for i in piece.wall_floor_level:
		collision_dict[i.coord_+coord] = true
func del_collision(coord : Vector2i, piece : level_piece) -> void:
	for i in piece.wall_floor_level:
		collision_dict.erase(i.coord_+coord)

func is_collision(coord : Vector2i, piece : level_piece) -> bool: ##Проверяет на пересечение
	for i in piece.wall_floor_level:
		if collision_dict.has(i.coord_+coord):
			return true 
	return false

func clear() -> void:
	collision_dict.clear()
