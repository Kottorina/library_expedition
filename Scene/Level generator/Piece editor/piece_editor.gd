@tool
extends Node2D

@export_group("tool")
@export var cell_to_rooms : Vector2i 
@export var room_size : Vector2i 
@export var tool_draw_node : TileMapLayer
@export_tool_button("tool_draw") var tool_draw_action = tool_draw_f

const ToolWallAtlas = Vector2i(12,0)
const ToolWallId = 0

func tool_draw_f():
	tool_draw_node.clear()
	
	for c_x in cell_to_rooms.x:
		for c_y in cell_to_rooms.y:
				for s_x in room_size.x:
						var coord_x = (room_size.x * c_x) + s_x
						var coord_y = (room_size.y * c_y) 
						
						var final_act_coord = Vector2i(coord_x,coord_y)
						tool_draw_node.set_cell(final_act_coord,ToolWallId,ToolWallAtlas)
				for s_y in room_size.y:
						var coord_x = (room_size.x * c_x) 
						var coord_y = (room_size.y * c_y) + s_y
						
						var final_act_coord = Vector2i(coord_x,coord_y)
						tool_draw_node.set_cell(final_act_coord,ToolWallId,ToolWallAtlas)
	
	var x_out = cell_to_rooms.x * room_size.x 
	var y_out = cell_to_rooms.y * room_size.y 
	
	for x in x_out:
		var final_act_coord = Vector2i(x,y_out)
		tool_draw_node.set_cell(final_act_coord,ToolWallId,ToolWallAtlas)
	
	for y in y_out :
		var final_act_coord = Vector2i(x_out,y)
		tool_draw_node.set_cell(final_act_coord,ToolWallId,ToolWallAtlas)
	
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
