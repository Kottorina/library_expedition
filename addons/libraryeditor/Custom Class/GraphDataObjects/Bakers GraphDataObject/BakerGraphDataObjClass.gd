extends Resource
class_name BakerGraphDataObject

var ui_const_func := UiConstFunc.new()
var graph_const := GraphNodeConstants.new()

var bake_data_dict : Dictionary ## ВСЕ ЗАПЕЧЕННЫЕ ДАННЫЕ

var free_nodes : Array[BigGraphNodeMakeInsts] ## ЕЩЕ НЕ ОБРАБОТАННЫЕ НОДЫ

var save_graph : Dictionary
var full_graph : Dictionary

var rnd : RandomNumberGenerator

## ВРЕМЕННО, ПОКА ВВИДЕ ОБРАЗЦА
var connection_plugs_instr : BigGraphNodeMakeInsts

func bake_data(graph_data_objects : GraphDataObjects, c_seed : int = 0) -> GraphDataObjects:
	
	save_graph = graph_data_objects.save_graph.duplicate(true)
	full_graph = graph_data_objects.full_graph.duplicate(true)
	
	rnd = RandomNumberGenerator.new()
	rnd.seed = c_seed
	
	free_nodes.append(graph_data_objects.start_bake_node)
	
	## ПРЕДВАРИТЕЛЬНАЯ ОБРАБОТКА, НАДО, ПРОСТО НАДО
	for node_instr : BigGraphNodeMakeInsts in save_graph: 
		match node_instr.type_node:
			4:
				connection_plugs_instr = node_instr 
	
	var callable = Callable(self, "bake_node")
	if not callable.is_valid():
		return
	
	while ! free_nodes.is_empty():
		
		var last_ind = free_nodes.size()-1
		callable.call(free_nodes[last_ind])
		free_nodes.remove_at(last_ind)
	
	graph_data_objects.bake_data = bake_data_dict
	
	var last_callable = Callable(self, "last_bake_call")
	if callable.is_valid():
		last_callable.call()
	
	return graph_data_objects






const ROOMNODENAME = "Room Node: "
const ROOMS_UI_LOCATIONS : String = "Locations"

func bake_ui(graph_data_objects_ar : Array) -> GraphDataObjectsUiSet:
	## graph_data_objects_ar : Array[GraphDataObjects]
	var new_graph_data_obj_ui_set := GraphDataObjectsUiSet.new()
	new_graph_data_obj_ui_set.ui_category = ROOMS_UI_LOCATIONS
	
	var callable = Callable(self, "from_GraphDataObjects_to_BigGraphNodeMakeInsts")
	if not callable.is_valid():
		return
	
	for obj_ind in graph_data_objects_ar.size():
		var current_obj = graph_data_objects_ar[obj_ind]
		if current_obj != null:
			var name_item : String = ROOMNODENAME + current_obj.name_+" "+str(obj_ind)
			var big_instr : BigGraphNodeMakeInsts = callable.call(current_obj)
			big_instr.title_node = name_item
			big_instr.graph_data_object = current_obj
			
			new_graph_data_obj_ui_set.biginstr_ar.append(big_instr)
	
	return new_graph_data_obj_ui_set

## ДОБАВЛЯЕТ НОДЫ ДЛЯ ПОСЛЕДУЮЩЕЙ ОБРАБОТКИ, СУКА
func AddFreePort(from_to_with : FromToWith) -> void:
	free_nodes.append(from_to_with.to_obj)

func get_free_ports(rom_to_with_ar : Array[FromToWith]) -> Array[FromToWith]:
	var free_ports_ar : Array[FromToWith]
		
	for port in rom_to_with_ar:
		if IsPortFree(port) == true:
			free_ports_ar.append(port)
		
	return free_ports_ar
	
func IsPortFree(from_to_with : FromToWith) -> bool:
	if from_to_with.to_obj is String:
		return false
	return true
	
