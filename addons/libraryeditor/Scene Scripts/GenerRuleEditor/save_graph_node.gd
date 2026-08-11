extends Node

@export var graph_edit: GraphEdit 

var occupied_ports : Dictionary ## { node : { const l/r : { 1 : true, 3 : true... } } }

const PORT_VALUE_FREE : String = "PortFree"
const PORT_VALUE_OCCUPIED : String = "PortOccupied"

const BIG_INSTR_NODE_DATA_NAME : String = "BigInstrNodeData" ## String --- Хранит тип нода, для быстрой выпечки
const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]
const ACTIVE_NODE_DATA_NAME  : String  = "ActiveNode" 

func bake_ready_location_f(ready_location : ReadyLocation) -> ReadyLocation:
	
	var bake_ready_location := ready_location.duplicate()
	
	
	var save_graph : Dictionary = {} ##Граф нужен для сохранения сцены
	var room_graph : Dictionary = {} ##Граф нужен для запекания комнат
	occupied_ports.clear()
	
	var start_gener_node = find_start_gener_node()
	if start_gener_node == null:
		print("Start Gener Is Broken")
		return ready_location
	
	var current_node : Node = start_gener_node
	var free_nodes : Dictionary ## { node (StringName) : true } --- Ноды которые нужно обработать
	free_nodes[current_node] = true
	
	bake_graph_node_biginstr() ## <-- СУКА! НЕ ЗАБУДЬ ПРО ДОПОЛНИТЕЛЬНУЮ ХТОНЬ В METADATA, ДЛЯ ЗАГРУЗКИ!!!
	
	var connection_plugs_instr : BigGraphNodeMakeInsts = null
	
	while !free_nodes.is_empty(): ## Первичная обработка
		
		current_node = free_nodes.keys()[0]
		var curent_node_big_instr : BigGraphNodeMakeInsts = current_node.get_meta(BIG_INSTR_NODE_DATA_NAME) ##Испольховать в графе, так как нужно только оно
		
		var right_ports : Array ## Все правые порты обьекта и их соеденения
		var right_data_meta : Array[GraphNodeMetadata] = current_node.get_meta(RIGHT_PORTS_DATA_NAME)
		for data in right_data_meta:
			right_ports.append({data : PORT_VALUE_FREE})
		
		var left_ports : Array ## Все левые порты обьекта и их соеденения 
		var left_data_meta : Array[GraphNodeMetadata] = current_node.get_meta(LEFT_PORTS_DATA_NAME)
		for data in left_data_meta:
			left_ports.append({data : PORT_VALUE_FREE})
		
		var connections = graph_edit.get_connection_list_from_node(current_node.name)
		for connect_line in connections:
			
			if current_node.name != connect_line["to_node"]:
				if  is_port_block(current_node.name,connect_line["from_port"],RIGHT_PORTS_DATA_NAME) == false:
					
					var to_left_big_instr_metadata = graph_edit.get_node( NodePath(connect_line["to_node"]) ).get_meta(BIG_INSTR_NODE_DATA_NAME)
					
					var to_left_metadata = graph_edit.get_node( NodePath(connect_line["to_node"]) ).get_meta(LEFT_PORTS_DATA_NAME)
					var final_meta = to_left_metadata[connect_line["to_port"]]
					
					var key_right = right_ports[connect_line["from_port"]].keys()[0]
					right_ports[connect_line["from_port"]][key_right] = [ final_meta, to_left_big_instr_metadata ]
					
					match to_left_big_instr_metadata.type_node:
						4:
							connection_plugs_instr = to_left_big_instr_metadata
					
					free_nodes[ graph_edit.get_node(NodePath(connect_line["to_node"])) ] = true
					block_port(connect_line["to_node"],connect_line["to_port"],LEFT_PORTS_DATA_NAME)
				
				else:
					var key_right = right_ports[connect_line["from_port"]].keys()[0]
					right_ports[connect_line["from_port"]][key_right] = PORT_VALUE_OCCUPIED
				
			
			if current_node.name != connect_line["from_node"]:
				if is_port_block(current_node.name,connect_line["to_port"],LEFT_PORTS_DATA_NAME) == false:
					
					var to_right_big_instr_metadata : BigGraphNodeMakeInsts = graph_edit.get_node( NodePath(connect_line["from_node"]) ).get_meta(BIG_INSTR_NODE_DATA_NAME)
					
					var from_right_metadata = graph_edit.get_node( NodePath(connect_line["from_node"]) ).get_meta(RIGHT_PORTS_DATA_NAME)
					var final_meta = from_right_metadata[connect_line["from_port"]]
					
					match to_right_big_instr_metadata.type_node:
						4:
							connection_plugs_instr = to_right_big_instr_metadata
					
					var key_left = left_ports[connect_line["to_port"]].keys()[0]
					left_ports[connect_line["to_port"]][key_left] = [ final_meta , to_right_big_instr_metadata ]
					
					free_nodes[ graph_edit.get_node(NodePath(connect_line["from_node"])) ] = true
					block_port(connect_line["from_node"],connect_line["from_port"],RIGHT_PORTS_DATA_NAME)
				
				else:
					var key_left = left_ports[connect_line["to_port"]].keys()[0]
					left_ports[connect_line["to_port"]][key_left] = PORT_VALUE_OCCUPIED
		
		free_nodes.erase(current_node)
		
		save_graph[curent_node_big_instr] = { LEFT_PORTS_DATA_NAME : left_ports, RIGHT_PORTS_DATA_NAME : right_ports}
	
	bake_ready_location.connection_plugs_instr = connection_plugs_instr
	bake_ready_location.save_graph = save_graph
	
	## Тестовое Финальное Запекание
	var baker = ReadyLocationBake.new()
	var fin_bake_ready_location = baker.bake_ready_location(bake_ready_location)
	
	return fin_bake_ready_location

func find_start_gener_node() -> Node:
	var start_ar : Array[Node]
	
	for child in graph_edit.get_children():
		if child is GraphNode:
			var meta_node : BigGraphNodeMakeInsts = child.get_meta(BIG_INSTR_NODE_DATA_NAME)
			if meta_node.type_node == 2:
				start_ar.append(child) 
	
	if start_ar.size() == 1:
		return start_ar[0] 
	return null

func bake_graph_node_biginstr() -> void: ## ДЛЯ ПОДГОНКИ ИНСТРУКЦИИ К ТЕКУЩЕМУ СОСТОЯНИЯ НОДА ВЫЗВАТЬ ПЕРЕД СОХРАНЕНИЕМ
	
	var graph_nodes_ar : Array[GraphNode]
	for child in graph_edit.get_children():
		if child is GraphNode:
			graph_nodes_ar.append(child)
	
	for graph_node in graph_nodes_ar:
		var big_instr : BigGraphNodeMakeInsts = graph_node.get_meta(BIG_INSTR_NODE_DATA_NAME).duplicate()
		big_instr.coord_ = graph_node.position_offset
		
		var ind = 0
		for child_node in graph_node.get_children():
			if child_node.has_meta(ACTIVE_NODE_DATA_NAME):
				var meta_data = child_node.get_meta(ACTIVE_NODE_DATA_NAME)
				if meta_data != null:
					big_instr.instr_ar[ind].body_value = meta_data.value
			ind += 1
		
		graph_node.set_meta(BIG_INSTR_NODE_DATA_NAME,big_instr)

func block_port(node_name : StringName, port : int, direction : String) -> void:
	if occupied_ports.has(node_name) and occupied_ports[node_name].has(direction):
		occupied_ports[node_name][direction].append(port)
	else:
		occupied_ports[node_name] = { direction : [port]}

func is_port_block(node_name : StringName, port : int, direction : String) -> bool:
	if occupied_ports.has(node_name) and occupied_ports[node_name].has(direction):
		if occupied_ports[node_name][direction].has(port):
			return true
	return false
