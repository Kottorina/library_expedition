@tool
extends Node

@export var draw_node : Node2D
@export var curent_level : level

@export var debug_seed : int
@export_tool_button("test") var test_action = test

func test():
	generate_level(curent_level)

var connectors_dict : Dictionary = { } ##piece_connector
var wall_floor_dict : Dictionary = { } ##piece_wall_floor...

func clear() -> void: ##Очистка отрисовки связанной с уровнем
	connectors_dict.clear()
	wall_floor_dict.clear()


const StartCoord = Vector2i(0,0)

func generate_level(curent_level_ : level):
	var rnd = RandomNumberGenerator.new()
	rnd.seed = debug_seed
	
	clear()
	
	place_piece(StartCoord,curent_level_.start_room) ##Стартовая комната
	
	place_corridors(curent_level_,rnd)
	
	draw_node.draw_wall_floor(wall_floor_dict)
	
	clear()

func place_corridors(curent_level_ : level,rnd_ : RandomNumberGenerator) -> void:
	
	var local_connectors_dict : Dictionary ##Нужен при локальной генерации
	
	for i in connectors_dict:
		var connector : piece_connector = connectors_dict[i]
		if connector.type == 1:
			local_connectors_dict[connector.coord_] = connector
	
	for step_global in curent_level_.corridor_step_generate:
		
		var new_step_connectors_dict : Dictionary = {}
		
		for c_key in local_connectors_dict:
			var connector : piece_connector = local_connectors_dict[c_key]
			
			var direction = connector.direction
			var coord_connector = c_key
			
			var min_max = curent_level_.corridor_min_max_long
			var number_piece = rnd_.randi_range(min_max.x,min_max.y)
			for step_local in number_piece:
				var piece_connectors = get_piece_connectors_from_set("base",direction,curent_level_.corridors_piece_set)
				
				var coord_new_connector = DIRECTION_VECTOR[direction] + coord_connector #Относительно крайнего коннектора
				var offset = coord_new_connector - piece_connectors[1].coord_ #Относительно нуля смешение
				
				place_piece(offset, piece_connectors[0])
				coord_connector = ((piece_connectors[2][0].coord_-piece_connectors[1].coord_) + coord_new_connector)

				if step_local+1 == number_piece:
					
					if step_global +1 != curent_level_.corridor_step_generate:
						
						piece_connectors = get_piece_connectors_from_set("fork",direction,curent_level_.corridors_piece_set)
				#
						coord_new_connector = DIRECTION_VECTOR[direction] + coord_connector #Относительно крайнего коннектора
						offset = coord_new_connector - piece_connectors[1].coord_ #Относительно нуля смешение
						place_piece(offset, piece_connectors[0])
						
						for p_c : piece_connector in piece_connectors[2]:
							coord_connector = ((p_c.coord_-piece_connectors[1].coord_) + coord_new_connector)
							new_step_connectors_dict[coord_connector] = p_c
							
		local_connectors_dict.clear()
		local_connectors_dict.merge(new_step_connectors_dict)
							
		#				new_st_cor_con.append_array(piece_connectors[2])
		#return
		#corridors_connectors = new_st_cor_con


const DIRECTION_VECTOR = {
	"down": Vector2i(0, 1),
	"up": Vector2i(0, -1),
	"left": Vector2i(-1, 0),
	"right": Vector2i(1, 0)
}
const DIRECTION_INV_STR = ["up","down","right","left"]

func get_piece_connectors_from_set(type : String,direction : String,corridor_set : piece_set_corridors): ##Часть, входной коннектор,выходные коннекторы
	match type:
		"base":
				for piece_ in corridor_set.pieces_base:
					for connector in piece_.connectors_level:
						if connector.direction == direction:
							
							var exit_connector : piece_connector
							var oth_connectors = piece_.connectors_level.duplicate()
							oth_connectors.erase(connector)
							
							return [piece_,connector,oth_connectors]
		"fork":
				for piece_ in corridor_set.pieces_fork:
					for connector in piece_.connectors_level:
						if connector.direction == direction and connector.type == 2:
							
							var oth_connectors = piece_.connectors_level.duplicate()
							oth_connectors.erase(connector)
							
							return [piece_,connector,oth_connectors]

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
