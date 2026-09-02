extends Resource
class_name BakerGraphDataObject

## КОНСТАНТЫ НУЖНЫ ДЛЯ РАБОТЫ С МЕТАДАННЫМИ И ПРОСТО ДАННЫМИ, НАДО КОРОЧЕ
const PORT_VALUE_FREE : String = "PortFree"
const PORT_VALUE_OCCUPIED : String = "PortOccupied"

const BIG_INSTR_NODE_DATA_NAME : String = "BigInstrNodeData" ## String --- Хранит тип нода, для быстрой выпечки
const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]
const ACTIVE_NODE_DATA_NAME  : String  = "ActiveNode" 

var free_nodes : Array[BigGraphNodeMakeInsts] ## ЕЩЕ НЕ ОБРАБОТАННЫЕ НОДЫ

var save_graph : Dictionary
var full_graph : Dictionary

var room_graph : Dictionary
var enters_location : Dictionary

var rnd : RandomNumberGenerator

var connection_plugs_instr : BigGraphNodeMakeInsts

const TOOLENTERTYPE : int = 17
const TOOLENTERCOLOR : Color = Color.PURPLE

func bake_data(graph_data_objects : GraphDataObjects, c_seed : int = 0) -> GraphDataObjects:
	
	save_graph = graph_data_objects.save_graph.duplicate(true)
	full_graph = graph_data_objects.full_graph.duplicate(true)
	
	rnd = RandomNumberGenerator.new()
	rnd.seed = c_seed
	
	enters_location.clear()

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
		
		var cur_node = free_nodes[0]
		callable.call(cur_node)
		
		free_nodes.remove_at(0)
	
	graph_data_objects.rooms_graph = room_graph
	graph_data_objects.enters_location = enters_location
	
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
