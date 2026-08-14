extends Control

@export var graph_edit: GraphEdit 

@export var ready_location_set_path : String

const BIG_INSTR_NODE_DATA_NAME : String = "BigInstrNodeData" ## String --- Хранит тип нода, для быстрой выпечки
const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]
const ACTIVE_NODE_DATA_NAME  : String  = "ActiveNode" 

func make_node_from_biginstr(big_instr : BigGraphNodeMakeInsts) -> GraphNode:
	
	var new_node = GraphNode.new()
	new_node.title = big_instr.title_node
	new_node.position_offset = big_instr.coord_ ## Для удобства менять при спавне от кнопки, СУКА
	
	var left_ports_data_ar : Array[GraphNodeMetadata] = [] ## Сам RES + active_node
	var right_ports_data_ar : Array[GraphNodeMetadata] = [] ## Сам RES + active_node
	
	var left_port_mum = 0
	var right_port_mum = 0
	
	var ind = 0
	for inst in big_instr.instr_ar:
		
		var active_node : Node = null ## НОД ДЛЯ ВООВДА ИНФЫ
		var child_node : Node = null ## ДОЧЕРНИЙ НОД С МЕТАДАННЫМИ
		
		match inst.body_node:
			0:
				child_node = Label.new()
				
				child_node.text = inst.title_instr
				new_node.add_child(child_node)
			1:
				active_node = SpinBox.new()
				child_node = HBoxContainer.new()
				
				new_node.add_child(child_node)
				var label = Label.new()
				label.text = inst.title_instr
				child_node.add_child(label)
				child_node.add_child(active_node)
				
				active_node.value = inst.body_value
		
		new_node.set_slot(ind,inst.is_left,inst.left_type,inst.left_color,inst.is_right,inst.right_type,inst.right_color)
		
		if inst.is_left == true:
			var metadata = GraphNodeMetadata.new()
			metadata.source_res = inst.source_res
			metadata.active_node = active_node
			metadata.port_num = left_port_mum
			left_ports_data_ar.append(metadata)
			
			left_port_mum += 1
			
		if inst.is_right == true:
			var metadata = GraphNodeMetadata.new()
			metadata.source_res = inst.source_res
			metadata.active_node = active_node
			metadata.port_num = right_port_mum
			right_ports_data_ar.append(metadata)
			
			right_port_mum += 1
		
		child_node.set_meta(ACTIVE_NODE_DATA_NAME,active_node)
		
		ind += 1
	
	new_node.set_meta(BIG_INSTR_NODE_DATA_NAME,big_instr)
	new_node.set_meta(LEFT_PORTS_DATA_NAME,left_ports_data_ar)
	new_node.set_meta(RIGHT_PORTS_DATA_NAME,right_ports_data_ar)
	
	graph_edit.add_child(new_node)
	return new_node

func load_graph(graph : Dictionary) -> void:
	
	clear_graph_scene()
	
	## СОБСВТЕННО ЗАГРУЗКА, ЧЕКНИ ГРАФ НА ХУЙНЮ А НЕ ДАННЫЕ
	
	## \\\...
	
	if graph.is_empty():
		return
	
	var ready_graph_nodes_from_instr : Dictionary ## BigInstr : Node
	
	for cur_ind in graph.keys().size():
		
		var curent_node : Node
		var curent_node_instr = graph.keys()[cur_ind]
		
		if !ready_graph_nodes_from_instr.has(curent_node_instr):
			curent_node = make_node_from_biginstr(curent_node_instr)
			ready_graph_nodes_from_instr[ graph.keys()[cur_ind] ] = curent_node
		else:
			curent_node = ready_graph_nodes_from_instr[curent_node_instr]
		
		for left_port : Dictionary in graph[curent_node_instr][LEFT_PORTS_DATA_NAME]:
			
			var start_port_meta : GraphNodeMetadata = left_port.keys()[0]
			if left_port[start_port_meta] is String:
				continue
			var end_port_meta : GraphNodeMetadata = left_port[start_port_meta][0]
			var final_node_instr : BigGraphNodeMakeInsts = left_port[start_port_meta][1]
			
			if ! ready_graph_nodes_from_instr.has(final_node_instr):
				ready_graph_nodes_from_instr[final_node_instr] = make_node_from_biginstr(final_node_instr)
			graph_edit.connect_node(ready_graph_nodes_from_instr[final_node_instr].name, end_port_meta.port_num,curent_node.name, start_port_meta.port_num)

			
		for right_port : Dictionary in graph[curent_node_instr][RIGHT_PORTS_DATA_NAME]:
			var start_port_meta : GraphNodeMetadata = right_port.keys()[0]
			if right_port[start_port_meta] is String:
				continue
			var end_port_meta : GraphNodeMetadata = right_port[start_port_meta][0]
			var final_node_instr : BigGraphNodeMakeInsts = right_port[start_port_meta][1]
			
			if ! ready_graph_nodes_from_instr.has(final_node_instr):
				ready_graph_nodes_from_instr[final_node_instr] = make_node_from_biginstr(final_node_instr)
			graph_edit.connect_node(curent_node.name, start_port_meta.port_num, ready_graph_nodes_from_instr[final_node_instr].name, end_port_meta.port_num)


func clear_graph_scene() -> void:
	
	## ОЧИСТИТЬ НАСТРОЙКИ ЕСЛИ ДОБАВЛЮ, ебала я вас всех
	
	graph_edit.clear_connections()
	for child in graph_edit.get_children():
		if child is GraphNode:
			child.queue_free()

func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if graph_edit.is_node_connected(from_node, from_port, to_node, to_port):
		graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
	else:
		graph_edit.connect_node(from_node, from_port, to_node, to_port)
var selected_node : Node
func _on_graph_edit_node_selected(node: Node) -> void:
	selected_node = node
@warning_ignore("unused_parameter")
func _on_graph_edit_node_deselected(node: Node) -> void:
	selected_node = null
func _on_del_node_pressed() -> void:
	if selected_node != null:
		selected_node.queue_free()
