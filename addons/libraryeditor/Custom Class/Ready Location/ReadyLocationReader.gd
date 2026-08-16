extends Node

class_name ReadyLocationLoader ## Для постепенной загрузки локации

signal load_new_parts( parts_ar : Array[BaseTile] )

signal ready_locatin_load_complete( enter_dict : Dictionary )

## "up","down","left","right"
const Direction : Dictionary = { 0 : Vector2i(0 , -1), 1 : Vector2i(0 , 1), 2 : Vector2i(-1 , 0), 3 : Vector2i(1 , 0) }

var parts_for_cycle : int = 100

var new_ready_location : ReadyLocation

var rnd : RandomNumberGenerator

func start_load(ready_location : ReadyLocation, seed : int = 0) -> void:
	
	rnd = RandomNumberGenerator.new()
	rnd.seed = seed
	
	## .duplicate(true) ПОЧЕМУ ТО НАХУЙ ЛОМАЕТ ПОИСК ВХОДНЫХ ТАЙЛОВ, НЕ ИСПОЛЬЗОВАТЬ СУКИ
	if seed != 0:
		var bake_node = ReadyLocationBake.new()
		new_ready_location = bake_node.bake_ready_location(ready_location,seed)
	else:
		new_ready_location = ready_location
	
	var free_rooms : Dictionary = { }
	var enter_dict : Dictionary = { } ## Id : Coord
	
	## ОТДЕЛЬНАЯ ОБРАБОТКА ПЕРВОЙ КОМНАТЫ НА ПРЕДМЕТ ENTER ТАК НАДО, ИНАЧЕ ВСЕ СЛОМАЕТЬСЯ
	for enters in new_ready_location.rooms_graph.keys()[0].room_enter_ar:
		if new_ready_location.enters_location.has(enters):
				enter_dict[ new_ready_location.enters_location[enters] ] = enters.coord_
	
	for room : Room in new_ready_location.rooms_graph.keys():
		
		load_room(room, parts_for_cycle)
		
		## ОБНОВИТЕ ПРИ СМЕНЕ КОМНАТЫ, БЛЯДИ
		
		for con_to_con : ConnectorToConnector in new_ready_location.rooms_graph[room]:
			var room_offset = con_to_con.from_connector.coord_ - con_to_con.to_connector.coord_ + Direction[con_to_con.from_connector.direction]
			for base_tile in con_to_con.to_room.base_tile:
				base_tile.coord_ = base_tile.coord_ + room_offset
			for connectors in con_to_con.to_room.room_connectors_ar:
				connectors.coord_ = connectors.coord_ + room_offset
			
			for enters in con_to_con.to_room.room_enter_ar:
				enters.coord_ = enters.coord_ + room_offset
				
				if new_ready_location.enters_location.has(enters):
					enter_dict[ new_ready_location.enters_location[enters] ] = enters.coord_
			
			if ! new_ready_location.rooms_graph.has(con_to_con.to_room):
				load_room(con_to_con.to_room, parts_for_cycle)
	
	ready_locatin_load_complete.emit(enter_dict)


var c_parts_ar = []
func load_room(room : Room, parts_max : int) -> void:
	
	print("!")
	
	for base_tile : BaseTile in room.base_tile:
		## ВОТ ТУТ ДЕКОР А RND ВЫШЕ
		if room.deco_istr_dict.has(base_tile.deco_type):
			var ind = rnd.randi_range(1, room.deco_istr_dict[base_tile.deco_type].size()-1)
			var new_deco_tile = room.deco_istr_dict[base_tile.deco_type][ind]
			if new_deco_tile is BaseTile:
				new_deco_tile.coord_ = base_tile.coord_
				new_deco_tile.deco_level = base_tile.deco_level + 1
				c_parts_ar.append(new_deco_tile)
		
		c_parts_ar.append(base_tile)
		
		if c_parts_ar.size() >= parts_max:
			load_new_parts.emit(c_parts_ar)
			c_parts_ar.clear()
	
	load_new_parts.emit(c_parts_ar)
