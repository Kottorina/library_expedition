@tool
extends Node

@export var draw_node : Node2D

@export var curent_level : level

@export var debug_seed : int
@export_tool_button("test") var test_action = test

@export_group("Under")
@export var corridor_generator : Node 
@export var collision_manager : Node

func test():
	generate_level(curent_level)

var connectors_dict : Dictionary = { } ##piece_connector
var wall_floor_dict : Dictionary = { } ##piece_wall_floor...

func clear() -> void: ##Очистка отрисовки связанной с уровнем
	connectors_dict.clear()
	wall_floor_dict.clear()
	collision_manager.clear()


const StartCoord = Vector2i(0,0)

func generate_level(curent_level_ : level):
	var rnd = RandomNumberGenerator.new()
	rnd.seed = debug_seed
	
	clear()
	
	place_piece(StartCoord,curent_level_.start_room) ##Стартовая комната
	
	var base_corridors_connector_dict : Dictionary = {}
	for i in connectors_dict:
		var connector : piece_connector = connectors_dict[i]
		if connector.type == 1:
			base_corridors_connector_dict[connector.coord_] = connector
	var corridor_paice_dict = corridor_generator.get_corridors(
		base_corridors_connector_dict,rnd,curent_level_.corridors_piece_set ,curent_level_.corridor_step_generate,curent_level_.corridor_min_max_long
		)
	for c_key in corridor_paice_dict:
		place_piece(c_key,corridor_paice_dict[c_key])
	
	draw_node.draw_wall_floor(wall_floor_dict)
	
	clear()

func place_piece(coord_piece : Vector2i, piece : level_piece):
	for i : piece_connector in piece.connectors_level: ##ТУТ ВСЕ ПЛОХО, ПОДУМАЙ
		connectors_dict[i.coord_ + coord_piece] = i
	for i : piece_wall_floor in piece.wall_floor_level:
		wall_floor_dict[i.coord_ + coord_piece] = i

func check_collision(coord : Vector2i, piece : level_piece) -> bool: ##Проверяет на пересечение
	for i in piece.wall_floor_level:
		if wall_floor_dict.has(coord+i.coord_):
			return false 
	
	return true
