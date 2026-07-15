@tool
extends Node

@export var collision_manager : Node

func get_corridors(
	connectors_dict : Dictionary,rnd_ : RandomNumberGenerator,corridor_set : piece_set_corridors ,step_generate : int,min_max_long : Vector2i
	) -> Dictionary:
	
	var paice_dict : Dictionary = {}
	
	for step_global in step_generate:
		
		var new_step_connectors_dict : Dictionary = {}
		
		for c_key in connectors_dict:
			var connector : piece_connector = connectors_dict[c_key]
			
			var direction = connector.direction
			var coord_connector = c_key
			
			var number_piece = rnd_.randi_range(min_max_long.x,min_max_long.y)
			for step_local in number_piece:
				var piece_connectors = get_piece_connectors_from_set("base",direction,corridor_set)
				
				var coord_new_connector = DIRECTION_VECTOR[direction] + coord_connector #Относительно крайнего коннектора
				var offset = coord_new_connector - piece_connectors[1].coord_ #Относительно нуля смешение
				
				if collision_manager.is_collision(offset,piece_connectors[0]) == false:
					collision_manager.make_collision(offset,piece_connectors[0])
					paice_dict[offset] = piece_connectors[0]
				else:
					break
				
				coord_connector = ((piece_connectors[2][0].coord_-piece_connectors[1].coord_) + coord_new_connector)

				if step_local+1 == number_piece:
					
					if step_global +1 != step_generate:
						
						piece_connectors = get_piece_connectors_from_set("fork",direction,corridor_set)
				#
						coord_new_connector = DIRECTION_VECTOR[direction] + coord_connector #Относительно крайнего коннектора
						offset = coord_new_connector - piece_connectors[1].coord_ #Относительно нуля смешение
						
						if collision_manager.is_collision(offset,piece_connectors[0]) == false and !paice_dict.has(offset):
							collision_manager.make_collision(offset,piece_connectors[0])
							paice_dict[offset] = piece_connectors[0]
						else:
							break
						
						for p_c : piece_connector in piece_connectors[2]:
							coord_connector = ((p_c.coord_-piece_connectors[1].coord_) + coord_new_connector)
							new_step_connectors_dict[coord_connector] = p_c
							
		connectors_dict.clear()
		connectors_dict.merge(new_step_connectors_dict)
	
	return paice_dict

const DIRECTION_VECTOR = {
	"down": Vector2i(0, 1),
	"up": Vector2i(0, -1),
	"left": Vector2i(-1, 0),
	"right": Vector2i(1, 0)
}

func get_piece_connectors_from_set(type : String,direction : String,corridor_set : piece_set_corridors): ##Часть, входной коннектор,выходные коннекторы
	match type:
		"base":
				for piece_ in corridor_set.pieces_base:
					for connector in piece_.connectors_level:
						if connector.direction == direction:
							
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
		"end":
				for piece_ in corridor_set.pieces_end:
					for connector in piece_.connectors_level:
						if connector.direction == direction:
							
							return [piece_,connector]
