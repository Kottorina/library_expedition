extends Node

@export var graph_edit: GraphEdit 

var occupied_ports : Dictionary ## { node : { const l/r : { 1 : true, 3 : true... } } }

var graph_const := GraphNodeConstants.new()

func SaveBakeGraph(editor_obj_layer : EditorObjectLayer, object : GraphDataObjects) -> GraphDataObjects:
	
	var start_gener_node = find_start_gener_node()
	if start_gener_node == null:
		push_warning("Start Gener Is Broken")
		return
	
	SynchronizationDataFromUI() ## <-- СУКА! НЕ ЗАБУДЬ ПРО ДОПОЛНИТЕЛЬНУЮ ХТОНЬ В METADATA, ДЛЯ ЗАГРУЗКИ!!!
	var cental_save_full_ar = GetCentradatalSaveFullGraph(start_gener_node)
	
	object.start_bake_node = start_gener_node.get_meta(graph_const.BIG_INSTR_NODE_DATA_NAME)
	object.central_data_graph = cental_save_full_ar[0]
	object.save_graph = cental_save_full_ar[1]
	object.full_graph = cental_save_full_ar[2]
	
	object.ui = get_scene_ui_graph()
	
	var baker_class = (editor_obj_layer.baker_object_script_path)
	if baker_class != null:
		var ready_baker : BakerGraphDataObject = baker_class.new()
		var bake_object = ready_baker.bake_data(object)
		return bake_object
	else:
		push_warning("Baker for "+ editor_obj_layer.data_key+" not find!")
	
	return object

func get_scene_ui_graph() -> SceneGraphUi:
	var new_graph_ui := SceneGraphUi.new()
	
	new_graph_ui.zoom = graph_edit.zoom
	new_graph_ui.scroll_offset = graph_edit.scroll_offset
	
	return new_graph_ui

func find_start_gener_node() -> Node:
	var start_ar : Array[Node]
	
	for child in graph_edit.get_children():
		if child is GraphNode:
			var meta_node : BigGraphNodeMakeInsts = child.get_meta(graph_const.BIG_INSTR_NODE_DATA_NAME)
			if meta_node.type_node == 2:
				start_ar.append(child) 
	
	if start_ar.size() == 1:
		return start_ar[0] 
	return null

## отдает [ savegraph, fullgraph ]
func GetCentradatalSaveFullGraph( start_gener_node : Node ) -> Array: 
	
	var centradata_graph : Dictionary = {}
	var save_graph : Dictionary = {} ##Граф нужен для сохранения сцены
	var full_graph : Dictionary = {}
	occupied_ports.clear()
	
	var current_node : Node = start_gener_node
	var free_nodes : Dictionary ## { node (StringName) : true } --- Ноды которые нужно обработать
	free_nodes[current_node] = true
	
	while !free_nodes.is_empty(): ## ЗАПОЛНЕНИЕ СОХРАНЕННОГО И ПОЛНОГО ГРАФА
		
		current_node = free_nodes.keys()[0]
		var curent_node_big_instr : BigGraphNodeMakeInsts = current_node.get_meta(graph_const.BIG_INSTR_NODE_DATA_NAME) ##Испольховать в графе, так как нужно только оно
		
		var right_ports : Array[FromToWith] ## Все правые порты обьекта и их соеденения
		var full_right_ports : Array[FromToWith]
		var right_data_meta : Array[GraphNodeMetadata] = current_node.get_meta(graph_const.RIGHT_PORTS_DATA_NAME)
		for data in right_data_meta: ## duplicate НЕ РАБОТАЕТ ТАК КАК Я ОТ НЕЕ ОЖИДАЛА, НЕ УДАЛЯТЬ КОСТЫЛЬ, ИНАЧЕ ДАМ ПИЗДЫ
			var from_to_obj := FromToWith.new()
			from_to_obj.from_data = data
			from_to_obj.to_obj = graph_const.PORT_VALUE_FREE
			right_ports.append(from_to_obj.duplicate())
			full_right_ports.append(from_to_obj.duplicate())
		
		var left_ports : Array[FromToWith] ## Все левые порты обьекта и их соеденения 
		var full_left_ports : Array[FromToWith]
		var left_data_meta : Array[GraphNodeMetadata] = current_node.get_meta(graph_const.LEFT_PORTS_DATA_NAME)
		for data in left_data_meta: ## duplicate НЕ РАБОТАЕТ ТАК КАК Я ОТ НЕЕ ОЖИДАЛА, НЕ УДАЛЯТЬ КОСТЫЛЬ, ИНАЧЕ ДАМ ПИЗДЫ
			var from_to_obj := FromToWith.new()
			from_to_obj.from_data = data
			from_to_obj.to_obj = graph_const.PORT_VALUE_FREE
			left_ports.append(from_to_obj.duplicate())
			full_left_ports.append(from_to_obj.duplicate())
		
		var connections = graph_edit.get_connection_list_from_node(current_node.name)
		for connect_line in connections:
			
			if current_node.name != connect_line["to_node"]:
				
				var to_left_big_instr_metadata = graph_edit.get_node( NodePath(connect_line["to_node"]) ).get_meta(graph_const.BIG_INSTR_NODE_DATA_NAME)
				
				var all_to_left_metadata = graph_edit.get_node( NodePath(connect_line["to_node"]) ).get_meta(graph_const.LEFT_PORTS_DATA_NAME)
				var to_left_metadata = all_to_left_metadata[connect_line["to_port"]]
				
				full_right_ports[connect_line["from_port"]].to_data = to_left_metadata
				full_right_ports[connect_line["from_port"]].to_obj = to_left_big_instr_metadata
				
				if  is_port_block(current_node.name,connect_line["from_port"],graph_const.RIGHT_PORTS_DATA_NAME) == false:
					right_ports[connect_line["from_port"]].to_data = to_left_metadata
					right_ports[connect_line["from_port"]].to_obj = to_left_big_instr_metadata

					free_nodes[ graph_edit.get_node(NodePath(connect_line["to_node"])) ] = true
					block_port(connect_line["to_node"],connect_line["to_port"],graph_const.LEFT_PORTS_DATA_NAME)
				else:
					right_ports[connect_line["from_port"]].to_obj = graph_const.PORT_VALUE_OCCUPIED
			
			if current_node.name != connect_line["from_node"]:
				
				var to_right_big_instr_metadata : BigGraphNodeMakeInsts = graph_edit.get_node( NodePath(connect_line["from_node"]) ).get_meta(graph_const.BIG_INSTR_NODE_DATA_NAME)
			
				var all_right_metadata = graph_edit.get_node( NodePath(connect_line["from_node"]) ).get_meta(graph_const.RIGHT_PORTS_DATA_NAME)
				var to_right_metadata = all_right_metadata[connect_line["from_port"]]
				
				full_left_ports[connect_line["to_port"]].to_data = to_right_metadata
				full_left_ports[connect_line["to_port"]].to_obj = to_right_big_instr_metadata
				
				if is_port_block(current_node.name,connect_line["to_port"],graph_const.LEFT_PORTS_DATA_NAME) == false:
					
					left_ports[connect_line["to_port"]].to_data = to_right_metadata
					left_ports[connect_line["to_port"]].to_obj = to_right_big_instr_metadata

					free_nodes[ graph_edit.get_node(NodePath(connect_line["from_node"])) ] = true
					block_port(connect_line["from_node"],connect_line["from_port"],graph_const.RIGHT_PORTS_DATA_NAME)
				
				else:
					left_ports[connect_line["to_port"]].to_obj = graph_const.PORT_VALUE_OCCUPIED

		free_nodes.erase(current_node)
		
		centradata_graph[curent_node_big_instr] = current_node.get_meta(graph_const.CENTRAL_DATA_NAME)
		save_graph[curent_node_big_instr] = { graph_const.LEFT_PORTS_DATA_NAME : left_ports, graph_const.RIGHT_PORTS_DATA_NAME : right_ports}
		full_graph[curent_node_big_instr] = { graph_const.LEFT_PORTS_DATA_NAME : full_left_ports, graph_const.RIGHT_PORTS_DATA_NAME : full_right_ports}
		
	return [ centradata_graph, save_graph, full_graph ]

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

func SynchronizationDataFromUI() -> void: ## ДЛЯ ПОДГОНКИ ИНСТРУКЦИИ К ТЕКУЩЕМУ СОСТОЯНИЯ НОДА ВЫЗВАТЬ ПЕРЕД СОХРАНЕНИЕМ
	
	var graph_nodes_ar : Array[GraphNode]
	for child in graph_edit.get_children():
		if child is GraphNode:
			graph_nodes_ar.append(child)
	
	for graph_node in graph_nodes_ar:
		var big_instr : BigGraphNodeMakeInsts = graph_node.get_meta(graph_const.BIG_INSTR_NODE_DATA_NAME)
		big_instr.coord_ = graph_node.position_offset
		
		var ind = 0
		for child_node in graph_node.get_children():
			if child_node.has_meta(graph_const.ACTIVE_NODE_DATA_NAME):
				var meta_data = child_node.get_meta(graph_const.ACTIVE_NODE_DATA_NAME)
				if meta_data != null:
					
					if meta_data is SpinBox:
							big_instr.instr_ar[ind].body_value = meta_data.value
					elif meta_data is TextEdit: 
							big_instr.instr_ar[ind].body_value = meta_data.text
			
			ind += 1
