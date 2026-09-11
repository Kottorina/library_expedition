extends Node

var ui_const_func := UiConstFunc.new()

## ПОДГРУЖАЮЮТЬСЯ ИЗ РОДИТЕЛЬСКОГО НОДА
#var room_set : RoomsSet
var cur_editor_obj_layer_ar : Array[EditorObjectLayer]
var cur_save_data_all_library : SaveDataAllLibrary

## НУЖНО В ОДНОМ МЕСТЕ
const DIRECTION_INVERT : Array[int] = [1,0,3,2] 

func bake_ui_editor_layer_nodes(data_str : String) -> Array:
	
	var cur_editor_layer : EditorObjectLayer
	for layer : EditorObjectLayer in cur_editor_obj_layer_ar:
		if layer.data_key == data_str:
			cur_editor_layer = layer
	
	if cur_editor_layer.baker_object_script_path == null:
		return []
	var baker : BakerGraphDataObject = cur_editor_layer.baker_object_script_path.new()
	if baker == null:
		return []
	var graph_obj_ar = cur_save_data_all_library.get_ar_from_key(cur_editor_layer.data_key)
	var graph_ui_ui_set : GraphDataObjectsUiSet = baker.bake_ui(graph_obj_ar)
	if graph_ui_ui_set == null:
		return []
	
	for big_instr in graph_ui_ui_set.biginstr_ar:
		return [graph_ui_ui_set.ui_category, big_instr]
	
	return []
	
#func bake_ui_rooms_nodes() -> Array:
	#for room_ind in room_set.rooms_ar.size():
		#
		#var current_room = room_set.rooms_ar[room_ind]
		#
		#if current_room != null:
			#var name_item : String = ui_const_func.ROOM_BIG_TITLE + current_room.name_+" "+str(room_ind)
			#
			#var big_instr = ui_const_func.room_to_big_instr_graphnode(current_room)
			#big_instr.title_node = name_item
			#big_instr.room_ = current_room
			#
			#graph_node_ui.AddNewUiItem(ui_const_func.ROOMS_UI_NAME, big_instr)

func bake_ui_enter_node() -> Array: ##Универсальный нод для обозначения входа на локу
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.ENTER_LOCATION_BIG_TITLE
	big_instr.type_node = 1
	
	big_instr.instr_ar.append(ui_const_func.get_tool_enter_instr())
	
	return [ui_const_func.TOOL_UI_NAME, big_instr]

func bake_ui_connectors_plugs() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.CONNECTORS_PLUGS_BIG_TITLE
	big_instr.type_node = 4
	
	big_instr.instr_ar.append(ui_const_func.get_tool_instr())
	
	for size_ in ui_const_func.SIZE.size():
		for type_ in ui_const_func.BASE_COLOR_TYPE.size():
			for direction_ in  ui_const_func.DIRECTION.size():
				var connector := RoomConnector.new()
				connector.type = type_
				connector.direction = direction_
				connector.size_ = size_
				big_instr.instr_ar.append(ui_const_func.get_inst_from_connector(connector))
	
	return [ui_const_func.TOOL_UI_NAME, big_instr]

func bake_ui_start_gener_node() -> Array: ##Стартовая хуйня, без нее генерация по пизде идет
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.START_GENER_LOCATION_BIG_TITLE
	big_instr.type_node = 2
	
	big_instr.instr_ar.append(ui_const_func.get_tool_instr())
	
	big_instr.instr_ar.append(ui_const_func.get_tool_enter_instr())
	
	return [ui_const_func.TOOL_UI_NAME, big_instr]

func bake_ui_start_gener_empty_node() -> Array:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ui_const_func.START_GENER_LOCATION_BIG_TITLE
	big_instr.type_node = 2
	
	big_instr.instr_ar.append(ui_const_func.get_tool_instr())
	
	return [ui_const_func.TOOL_UI_NAME, big_instr]

func bake_ui_all_rnd_fork() -> void: ## Случайные Перекрестки, Очень Круто
	for type_ in ui_const_func.BASE_COLOR_TYPE.size():
		for size_ in ui_const_func.SIZE.size():
			for direction_ in ui_const_func.DIRECTION.size():
				var connector := RoomConnector.new()
				connector.type = type_
				connector.direction = direction_
				connector.size_ = size_
				bake_ui_rnd_fork_from_connector(connector)

func bake_ui_rnd_fork_from_connector( enter_connector : RoomConnector ) -> Array: ## Случайные Перекрестки, Очень Круто
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.type_node = 5
	
	big_instr.instr_ar.append(ui_const_func.get_tool_instr())
	
	var enter_instr = ui_const_func.get_inst_from_connector(enter_connector)
	big_instr.instr_ar.append(enter_instr)
	
	var big_title = ui_const_func.BIG_RND_FORK_BIG_TITLE + " " + enter_instr.title_instr
	
	big_instr.title_node = big_title
	
	var exit_connector = enter_connector.duplicate()
	exit_connector.direction = DIRECTION_INVERT[enter_connector.direction]
	var exit_instr_one = ui_const_func.get_inst_from_connector(exit_connector)
	exit_instr_one.title_instr = ui_const_func.INSTR_FORK_BASE_TITLE
	big_instr.instr_ar.append(exit_instr_one)
	
	var exit_instr_two = ui_const_func.get_inst_from_connector(exit_connector)
	exit_instr_two.body_node = 1
	exit_instr_two.title_instr = ui_const_func.INSTR_FORK_ALT_CHANCE_TITLE
	big_instr.instr_ar.append(exit_instr_two)
	
	return [ui_const_func.TOOL_FORK_UI_NAME, big_instr]
	
func bake_ui_crossroad_2() -> Array:
	var big_instr = get_crossroad(2)
	return [ui_const_func.TOOL_UI_NAME, big_instr]
func bake_ui_crossroad_4() -> Array:
	var big_instr = get_crossroad(4)
	return [ui_const_func.TOOL_UI_NAME, big_instr]
func bake_ui_crossroad_6() -> Array:
	var big_instr = get_crossroad(6)
	return [ui_const_func.TOOL_UI_NAME, big_instr]
	
func get_crossroad( num_choise : int ) -> BigGraphNodeMakeInsts:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = " ".join([ui_const_func.TOOL_TITLE,str(num_choise)])  
	big_instr.type_node = 0
	
	for i in num_choise:
		big_instr.instr_ar.append(ui_const_func.get_tool_instr())
	
	return big_instr

## А НАХУЙ, ПОДУМАЙ, БЛЯДЬ (это обращение)
#func bake_custom_big_instr() -> void:
	#for big_instr in main_graph_editor.custom_big_instr_ar:
		#var new_big_intr = big_instr.duplicate(true)
		#graph_node_ui.AddNewUiItem(new_big_intr.ui_category, new_big_intr)
