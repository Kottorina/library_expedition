@tool
extends Node2D

@export var wall_floor_tile : TileMapLayer

func draw_wall_floor(wall_floor_dict : Dictionary) -> bool:
	
	clear()
	
	for coord_key : Vector2i in wall_floor_dict:
		var p_w_f : piece_wall_floor = wall_floor_dict[coord_key]
		wall_floor_tile.set_cell(coord_key,0,p_w_f.atl_coord_)
	
	return true 

@export_tool_button("Clear") var clear_action = clear
func clear():
	wall_floor_tile.clear()
