@tool
extends Node2D

@export var current_room_set_path : String

@export var deco_nodes_ar : Array[TileMapLayer]
@export var gener_node : TileMapLayer

@export var tool_draw_node : TileMapLayer
@export_tool_button("tool_draw") var tool_draw_action = tool_draw_f

const ToolWallAtlas = Vector2i(12,0)
const TOOLSOURCEID = 0

func tool_draw_f():
	
	var r_s = ResourceLoader.load(current_room_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
	tool_draw_node.clear()
	
	for c_x in r_s.cell_to_rooms.x:
		for c_y in r_s.cell_to_rooms.y:
				for s_x in r_s.room_size.x:
						var coord_x = (r_s.room_size.x * c_x) + s_x
						var coord_y = (r_s.room_size.y * c_y) 
						
						var final_act_coord = Vector2i(coord_x,coord_y)
						tool_draw_node.set_cell(final_act_coord,TOOLSOURCEID,ToolWallAtlas)
				for s_y in r_s.room_size.y:
						var coord_x = (r_s.room_size.x * c_x) 
						var coord_y = (r_s.room_size.y * c_y) + s_y
						
						var final_act_coord = Vector2i(coord_x,coord_y)
						tool_draw_node.set_cell(final_act_coord,TOOLSOURCEID,ToolWallAtlas)
	
	var x_out = r_s.cell_to_rooms.x * r_s.room_size.x 
	var y_out = r_s.cell_to_rooms.y * r_s.room_size.y 
	
	for x in x_out:
		var final_act_coord = Vector2i(x,y_out)
		tool_draw_node.set_cell(final_act_coord,TOOLSOURCEID,ToolWallAtlas)
	
	for y in y_out :
		var final_act_coord = Vector2i(x_out,y)
		tool_draw_node.set_cell(final_act_coord,TOOLSOURCEID,ToolWallAtlas)

@export_tool_button("Read Set") var read_action = read
func read():
	
	clear_f() #Очиста перед отрисовкой
	
	tool_draw_f()
	
	var current_room_set = ResourceLoader.load(current_room_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
	
	for room_id in current_room_set.rooms_ar.size():
		if current_room_set.rooms_ar[room_id] == null:
			continue
		@warning_ignore("integer_division")
		var coord_chunk = Vector2i(room_id % current_room_set.cell_to_rooms.y,room_id / current_room_set.cell_to_rooms.y)
		
		if current_room_set.rooms_ar[room_id].base_tile != null:
			for base_tile : BaseTile in current_room_set.rooms_ar[room_id].base_tile:
				var coord_tile = base_tile.coord_ + Vector2i(coord_chunk.x*current_room_set.room_size.x,coord_chunk.y*current_room_set.room_size.y)
				deco_nodes_ar[base_tile.deco_level].set_cell(coord_tile,base_tile.id_,base_tile.atl_coord_)
		
		if current_room_set.rooms_ar[room_id].room_connectors_ar != null:
			
			for room_connectors : RoomConnector in current_room_set.rooms_ar[room_id].room_connectors_ar:
				var coord_tile = room_connectors.coord_ + Vector2i(coord_chunk.x*current_room_set.room_size.x,coord_chunk.y*current_room_set.room_size.y)
				match room_connectors.type:
					0:
						var atl_coord = Vector2i(CONNECTORBLACKSTART.x + room_connectors.size_,CONNECTORBLACKSTART.y + room_connectors.direction)
						gener_node.set_cell(coord_tile,TOOLSOURCEID,atl_coord)
					1:
						var atl_coord = Vector2i(CONNECTORGRAYSTART.x + room_connectors.size_,CONNECTORGRAYSTART.y + room_connectors.direction)
						gener_node.set_cell(coord_tile,TOOLSOURCEID,atl_coord)
					2:
						var atl_coord = Vector2i(CONNECTORWHITESTART.x + room_connectors.size_,CONNECTORWHITESTART.y + room_connectors.direction)
						gener_node.set_cell(coord_tile,TOOLSOURCEID,atl_coord)

## "up","down","left","right" ПРОРИСОВАТЬ В TILESET ДЛЯ ПОМЕТКИ КОННЕКТОРОВ, СУКА (gener_type) ## Connector,
const CONNECTORBLACKSTART := Vector2i(13,0)
const CONNECTORGRAYSTART := Vector2i(13,4)
const CONNECTORWHITESTART := Vector2i(13,8)

@export_tool_button("Write Set") var clear_action = write
func write():
	
	var new_room_set = RoomsSet.new() 
	new_room_set = ResourceLoader.load(current_room_set_path).duplicate()
	new_room_set.rooms_ar.clear()
	new_room_set.rooms_ar.resize(new_room_set.cell_to_rooms.x*new_room_set.cell_to_rooms.y)
	
	##Запись декораций
	var heigt = 0
	for deco_tilemap in deco_nodes_ar:
		
		for coord in deco_tilemap.get_used_cells():
			var coord_chunk := Vector2(coord.x/new_room_set.room_size.x,coord.y/new_room_set.room_size.y)
			var id_ar = int(coord_chunk.y * new_room_set.cell_to_rooms.y + coord_chunk.x)
			
			var new_base_tile = BaseTile.new()
			new_base_tile.coord_ = coord - Vector2i(coord_chunk.x*new_room_set.room_size.x,coord_chunk.y*new_room_set.room_size.y)
			new_base_tile.atl_coord_ = deco_tilemap.get_cell_atlas_coords(coord)
			new_base_tile.id_ = deco_tilemap.get_cell_source_id(coord)
			new_base_tile.deco_level = heigt
			
			if new_room_set.rooms_ar[id_ar] != null:
				new_room_set.rooms_ar[id_ar].base_tile.append(new_base_tile)
			else:
				new_room_set.rooms_ar[id_ar] = Room.new()
				new_room_set.rooms_ar[id_ar].base_tile.append(new_base_tile)
			
		heigt += 1
	
	##Запись правил для генерации
	for coord in gener_node.get_used_cells():
		var coord_chunk := Vector2(coord.x/new_room_set.room_size.x,coord.y/new_room_set.room_size.y)
		var id_ar = int(coord_chunk.y * new_room_set.cell_to_rooms.y + coord_chunk.x)
		
		if new_room_set.rooms_ar[id_ar] == null:
			new_room_set.rooms_ar[id_ar] = Room.new()
		
		var type_gener = gener_node.get_cell_tile_data(coord)
		var gener_type = type_gener.get_custom_data("gener_type")
		match gener_type:
			"ConnectorBlack", "ConnectorGray", "ConnectorWhite":
				var new_roomconnector = give_connector_from_coord(coord,gener_coord_dict[gener_type],gener_type_dict[gener_type])
				new_roomconnector.coord_ = coord - Vector2i(coord_chunk.x*new_room_set.room_size.x,coord_chunk.y*new_room_set.room_size.y)
				new_room_set.rooms_ar[id_ar].room_connectors_ar.append(new_roomconnector)
			"EnterBlack", "EnterGray", "EnterWhite":
				var room_enter = RoomEnter.new()
				room_enter.type = gener_type_dict[gener_type]
				room_enter.coord_ = coord - Vector2i(coord_chunk.x*new_room_set.room_size.x,coord_chunk.y*new_room_set.room_size.y)
				new_room_set.rooms_ar[id_ar].room_enter_ar.append(room_enter)
	
	ResourceSaver.save(new_room_set, current_room_set_path) 

var gener_type_dict = {
"ConnectorBlack": 0, "EnterBlack": 0, "ConnectorGray": 1, "EnterGray": 1, "ConnectorWhite": 2, "EnterWhite": 2
}
var gener_coord_dict = {
"ConnectorBlack": CONNECTORBLACKSTART,"ConnectorGray": CONNECTORGRAYSTART, "ConnectorWhite": CONNECTORWHITESTART,
}

func give_connector_from_coord(coord : Vector2i,atl_coord : Vector2i,type : int) -> RoomConnector:
	var new_roomconnector := RoomConnector.new()
	new_roomconnector.direction = (gener_node.get_cell_atlas_coords(coord) - atl_coord).y
	new_roomconnector.size_ = (gener_node.get_cell_atlas_coords(coord) - atl_coord).x
	new_roomconnector.type = type
	return new_roomconnector

@export_tool_button("Clear") var clear_f_action = clear_f
func clear_f():
	for deco_tilemap in deco_nodes_ar:
		deco_tilemap.clear()
	gener_node.clear()
	tool_draw_node.clear()
	
	#var x_out = cell_to_rooms.x * room_size.x 
	#for y_out in cell_to_rooms.x * room_size.x :
		#var final_act_coord = Vector2i(x_out,y_out)
		#tool_draw_node.set_cell(final_act_coord,ToolWallId,ToolWallAtlas)
#@export var level_piece_ : level_piece
#
#@export_tool_button("Clear") var clear_action = clear
#
#func clear():
	##level_piece_.min_max_coord = Vector4i.ZERO
	##level_piece_.connectors_level.clear()
	##level_piece_.wall_floor_level.clear()
	#var wall_floor: TileMapLayer = $wall_floor
	#var debug: TileMapLayer = $debug
	#wall_floor.clear()
	#debug.clear()
	#
#@export_tool_button("Read") var read_action = read
#
#func read():
	#
	#clear()
	#
	#var wall_floor: TileMapLayer = $wall_floor
	#var debug: TileMapLayer = $debug
	#
	#for i in level_piece_.wall_floor_level:
		#wall_floor.set_cell(i.coord_,0,i.atl_coord_)
	#
	#for i in level_piece_.connectors_level:
		#var atl_coord : Vector2i = Vector2i.ZERO
		#match i.direction:
			#"down":
				#atl_coord.y = 0
			#"up":
				#atl_coord.y = 1
			#"left":
				#atl_coord.y = 2
			#"right":
				#atl_coord.y = 3
		#atl_coord.y += i.type * 4
		#atl_coord.x = i.size_ -1
		#debug.set_cell(i.coord_,1,atl_coord)
#
#@export_tool_button("Write") var write_action = write
#
#var direction_base = ["down","up","left","right"]
#
#func write():
	#
	#var min_x = INF
	#var min_y = INF
	#var max_x = -INF
	#var max_y = -INF
	#var wall_floor_dict : Dictionary
	#var connector_ar : Array = []
	#level_piece_.connectors_level.clear()
	#level_piece_.wall_floor_level.clear()
	#
	#for i in get_children():
		#if i is TileMapLayer:
			#var tile_map : TileMapLayer = i
			#for tile_coord in tile_map.get_used_cells():
				#
				#var id_source = tile_map.get_cell_source_id(tile_coord)
				#var atl_coord = tile_map.get_cell_atlas_coords(tile_coord)
				#
				#match id_source:
					#0:
						#var wall_floor = piece_wall_floor.new()
						#wall_floor.coord_ = tile_coord
						#wall_floor.atl_coord_ = atl_coord
						##wall_floor.height_ ПОТОМ ДОПИШИ СУК
						#
						#wall_floor_dict[tile_coord] = wall_floor
						#
						#min_x = min(min_x, tile_coord.x)
						#min_y = min(min_y, tile_coord.y)
						#max_x = max(max_x, tile_coord.x)
						#max_y = max(max_y, tile_coord.y)
					#1:
						#if atl_coord.y <= 11:
							#var connector = piece_connector.new()
							#connector.coord_ = tile_coord
							#connector.size_ = atl_coord.x + 1
							#var dir = atl_coord.y
							#dir %= 4
							#connector.direction = direction_base[dir]
							#var type_ = ceil(float(atl_coord.y+1)/4.0)
							#connector.type = int(type_)-1
							#connector_ar.append(connector)
	#
	#var ar = []
	#for i in wall_floor_dict:
		#ar.append(wall_floor_dict[i])
		#level_piece_.wall_floor_level = ar
		#
	#level_piece_.connectors_level = connector_ar
	#
	#level_piece_.min_max_coord = Vector4i(min_x,min_y,max_x,max_y)
