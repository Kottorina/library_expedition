extends Node

@export var graph_edit: GraphEdit 
@export var gener_rule_editor : Control

const SPINBOX_BASE_STEP : float = 0.1

const ACTIVE_NODE_DATA_NAME  : String  = "ActiveNode" 
const BIG_INSTR_NODE_DATA_NAME : String = "BigInstrNodeData" ## String --- Хранит тип нода, для быстрой выпечки

const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]


func LoadUiSet( scene_graph_ui : SceneGraphUi ) -> void:
	if scene_graph_ui != null:
		graph_edit.zoom = scene_graph_ui.zoom
		graph_edit.scroll_offset = scene_graph_ui.scroll_offset

func make_node_from_biginstr(big_instr : BigGraphNodeMakeInsts) -> GraphNode:
	
	var room_set : RoomsSet = ResourceLoader.load(
		gener_rule_editor.room_set_path,"",ResourceLoader.CACHE_MODE_IGNORE
		)
	for new_room : Room in room_set.rooms_ar:
		if new_room != null and big_instr.room_ != null:
			if big_instr.room_.id_ == new_room.id_:
				
				big_instr.room_.update_room_from_new_room(new_room) 
				big_instr.room_.deco_istr_dict = room_set.deco_istr_dict
	
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
				active_node.step = SPINBOX_BASE_STEP
				child_node = HBoxContainer.new()
				
				new_node.add_child(child_node)
				var label = Label.new()
				label.text = inst.title_instr
				child_node.add_child(label)
				child_node.add_child(active_node)
				
				if inst.body_value != null:
					active_node.value = inst.body_value
				else:
					inst.body_value = 0
					active_node.value = inst.body_value
		
		new_node.set_slot(ind,inst.is_left,inst.left_type,inst.left_color,inst.is_right,inst.right_type,inst.right_color)
		
		if inst.is_left == true:
			var metadata = GraphNodeMetadata.new()
			metadata.source_res = inst.source_res
			metadata.port_num = left_port_mum
			left_ports_data_ar.append(metadata)
			
			left_port_mum += 1
			
		if inst.is_right == true:
			var metadata = GraphNodeMetadata.new()
			metadata.source_res = inst.source_res
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

## ЗАГРУЗКА SAVEGRAPH, гав гав
func LoadSaveGraph(save_graph : Dictionary) -> void:
	
	ClearGraphScene()
	if save_graph.is_empty():
		return
	
	## ЗАГРУЗКА НОДОВ
	#var ready_graph_nodes_from_instr : Dictionary ## BigInstr : Node
	
	var big_instr_to_node : Dictionary
	
	for big_instr in save_graph.keys():
		var new_node = make_node_from_biginstr(big_instr)
		big_instr_to_node[big_instr] = new_node
		
	for big_instr in save_graph.keys():
		## ЗАГРУЗКА СОЕДИНЕНИЙ
		for left_port : FromToWith in save_graph[big_instr][LEFT_PORTS_DATA_NAME]:
			
			if left_port.to_obj is String:
				continue
			LoadConnect(big_instr_to_node[big_instr],left_port,big_instr_to_node[left_port.to_obj])
			
		for right_port : FromToWith in save_graph[big_instr][RIGHT_PORTS_DATA_NAME]:
			
			if right_port.to_obj is String:
				continue
			LoadConnect(big_instr_to_node[big_instr],right_port,big_instr_to_node[right_port.to_obj])

func LoadConnect(from_node : Node, from_to_with : FromToWith,to_obj : Node) -> void:
	
	graph_edit.connect_node(
		from_node.name,from_to_with.from_data.port_num,to_obj.name, from_to_with.to_data.port_num
		)
	
func ClearGraphScene() -> void:
	
	## ОЧИСТИТЬ НАСТРОЙКИ ЕСЛИ ДОБАВЛЮ, ебала я вас всех
	
	graph_edit.clear_connections()
	for child in graph_edit.get_children():
		if child is GraphNode:
			child.queue_free()



var selected_node : Node
func _on_del_node_pressed() -> void:
	if selected_node != null:
		selected_node.queue_free()
func _on_main_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if graph_edit.is_node_connected(from_node, from_port, to_node, to_port):
		graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
	else:
		graph_edit.connect_node(from_node, from_port, to_node, to_port)
		
@warning_ignore("unused_parameter")
func _on_main_graph_edit_node_deselected(node: Node) -> void:
	selected_node = null
func _on_main_graph_edit_node_selected(node: Node) -> void:
	selected_node = node
