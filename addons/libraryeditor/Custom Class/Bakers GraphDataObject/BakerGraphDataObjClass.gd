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

func bake(graph_data_objects : GraphDataObjects, c_seed : int = 0) -> GraphDataObjects:
	var new_graph_data_objects = graph_data_objects.duplicate()
	
	save_graph = new_graph_data_objects.save_graph.duplicate(true)
	full_graph = new_graph_data_objects.full_graph.duplicate(true)
	
	rnd = RandomNumberGenerator.new()
	rnd.seed = c_seed
	
	enters_location.clear()

	free_nodes.append(new_graph_data_objects.start_bake_node)
	
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
	
	new_graph_data_objects.rooms_graph = room_graph
	new_graph_data_objects.enters_location = enters_location
	
	return new_graph_data_objects
