extends BakerGraphDataObject
class_name BigReadyLocationBaker

## ДОБАВЛЯЕТ НОДЫ ДЛЯ ПОСЛЕДУЮЩЕЙ ОБРАБОТКИ, СУКА
func add_free_port(port : Dictionary) -> void:
	if ! port[port.keys()[0]] is String:
		free_nodes.append(port[port.keys()[0]][1])

func bake_node(nodes : BigGraphNodeMakeInsts) -> void:
	match nodes.type_node:
		8: ## ОБРАБОТКА ПОРТОВ У MAKE LOCATION
			for left_port : Dictionary in save_graph[nodes][LEFT_PORTS_DATA_NAME]:
				room_bake_not_free_port(save_graph,nodes,left_port,LEFT_PORTS_DATA_NAME)
				room_bake_free_port(save_graph,nodes,left_port,LEFT_PORTS_DATA_NAME)
				add_free_port(left_port)
			## ДЛЯ ПРАВЫХ ПОРТОВ, НАХУЙ ФАШИСТОВ
			for right_port : Dictionary in save_graph[nodes][RIGHT_PORTS_DATA_NAME]:
				room_bake_not_free_port(save_graph,nodes,right_port,RIGHT_PORTS_DATA_NAME)
				room_bake_free_port(save_graph,nodes,right_port,RIGHT_PORTS_DATA_NAME)
				add_free_port(right_port)

func room_bake_not_free_port(save_graph : Dictionary, from_node_instr : BigGraphNodeMakeInsts , port, const_name : String) -> void:
	if ! port[port.keys()[0]] is Array:
		return
	var from_meta = port.keys()[0]
	var to_port_meta : GraphNodeMetadata = port[port.keys()[0]][0]
	var to_node_instr : BigGraphNodeMakeInsts = port[port.keys()[0]][1]
	bake_con_to_con(save_graph,from_meta,from_node_instr,to_port_meta,to_node_instr,const_name)

func bake_con_to_con(
	save_graph : Dictionary,from_meta : GraphNodeMetadata, from_node_instr : BigGraphNodeMakeInsts, to_port_meta : GraphNodeMetadata, to_node_instr : BigGraphNodeMakeInsts , const_name : String
	) -> void:
	
	pass
	
	#if to_node_instr.type_node == 0 and to_port_meta.source_res is RoomConnector:
		#
		#var new_co_to_con := new_id_to_id(
		#from_meta.source_res,to_port_meta.source_res,to_node_instr.room_)
		#if room_graph.has(from_node_instr.room_):
			#room_graph[from_node_instr.room_].append(new_co_to_con)
		#else:
			#room_graph[from_node_instr.room_] = [new_co_to_con]
		#
	#elif to_node_instr.type_node == 1:
		#
		#var value = to_port_meta.active_node.value
		#var enter : RoomEnter = save_graph[from_node_instr][const_name][to_port_meta.port_num].keys()[0].source_res
		#
		#enters_location[enter] = value

func new_id_to_id(from_id : int,to_id : int,to_location : GraphDataObjects) -> IdEnterToIdEnter:
	var id_to_id := IdEnterToIdEnter.new()
	id_to_id.from_id = from_id
	id_to_id.to_id = to_id
	id_to_id.to_data = to_location
	
	return id_to_id


func room_bake_free_port(save_graph : Dictionary, from_node_instr : BigGraphNodeMakeInsts , port, const_name : String) -> void:
	return
