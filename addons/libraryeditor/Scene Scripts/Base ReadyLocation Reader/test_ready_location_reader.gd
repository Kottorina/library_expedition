@tool
extends Node2D

@export var cur_seed : int = 0
@export var seed_auto_add : bool = true

@export var path_current_ready_location_set : String
@export var location_ind : int

@export var parts_for_cycle : int = 30

@export var draw_ar : Array[TileMapLayer]

var final_enter_dict : Dictionary

@export_tool_button("Read Set") var read_action = read
func read():
	clear_f()
	
	var ready_locations_set : ReadyLocationSet = ResourceLoader.load(path_current_ready_location_set,"",ResourceLoader.CACHE_MODE_IGNORE)
	var ready_locations = ready_locations_set.ready_location_ar[location_ind]
	
	var location_loader := ReadyLocationLoader.new()
	
	location_loader.load_new_parts.connect(draw_parts)
	location_loader.ready_locatin_load_complete.connect(end_load_ready_location)
	location_loader.parts_for_cycle = parts_for_cycle
	
	location_loader.start_load(ready_locations,cur_seed)
	if seed_auto_add == true:
		cur_seed += 1

func draw_parts( parts_ar : Array ) -> void: ## Array[BaseTile] ВЫДАЕТ ОШИБКУ, КАКОГО ТО ХУЯ
	for base_tile : BaseTile in parts_ar:
		draw_ar[base_tile.deco_level].set_cell(base_tile.coord_,base_tile.id_,base_tile.atl_coord_)
	#print(parts_ar)

@export_tool_button("Clear") var clear_f_action = clear_f
func clear_f():
	for draw in draw_ar:
		draw.clear()

func end_load_ready_location( enter_dict : Dictionary ) -> void:
	final_enter_dict = enter_dict
	print(final_enter_dict)
