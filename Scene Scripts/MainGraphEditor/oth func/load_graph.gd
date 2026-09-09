extends Node

@export var graph_edit: GraphEdit 
@export var main_graph_editor : Node

## НАСТРОЙКИ UI В GRAPH NODE
#Label
const LABEL_HORIZONTAL_ALIGNMENT = HORIZONTAL_ALIGNMENT_CENTER
#SpinBox
const SPINBOX_BASE_STEP : float = 0.1
#TextEdit
const TEXT_FIT_CONTENT_HEIGHT : bool = true
const TEXT_FIT_CONTENT_WIDTH : bool = true
const TEXT_MINIMUM_SIZE_X : int = 150

const ACTIVE_NODE_DATA_NAME  : String  = "ActiveNode" 
const BIG_INSTR_NODE_DATA_NAME : String = "BigInstrNodeData" ## String --- Хранит тип нода, для быстрой выпечки

const CENTRAL_PORTS_DATA_NAME  : String  = "CentralPortsData" ## Array[Metadata...]
const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]


func LoadUiSet( scene_graph_ui : SceneGraphUi ) -> void:
	if scene_graph_ui != null:
		graph_edit.zoom = scene_graph_ui.zoom
		graph_edit.scroll_offset = scene_graph_ui.scroll_offset

func MakeNodeFromBigInstr(big_instr : BigGraphNodeMakeInsts) -> GraphNode:
	
	var room_set : RoomsSet = ResourceLoader.load(
		main_graph_editor.room_set_path,"",ResourceLoader.CACHE_MODE_IGNORE
		)
	for new_room : Room in room_set.rooms_ar:
		if new_room != null and big_instr.room_ != null:
			if big_instr.room_.id_ == new_room.id_:
				
				big_instr.room_.update_room_from_new_room(new_room) 
				big_instr.room_.deco_istr_dict = room_set.deco_istr_dict
	
	var new_node = GraphNode.new()
	new_node.title = big_instr.title_node
	new_node.position_offset = big_instr.coord_ ## Для удобства менять при спавне от кнопки, СУКА
	
	var central_ports_data_ar : Array[GraphNodeMetadata] = [] ## Сам RES + active_node
	var left_ports_data_ar : Array[GraphNodeMetadata] = [] ## Сам RES + active_node
	var right_ports_data_ar : Array[GraphNodeMetadata] = [] ## Сам RES + active_node
	
	var left_port_mum = 0
	var right_port_mum = 0
	
	var ind = 0
	for inst in big_instr.instr_ar:
		
		var active_node : Node = null ## НОД ДЛЯ ВООВДА ИНФЫ
		var child_node : Node = null ## ДОЧЕРНИЙ НОД С МЕТАДАННЫМИ
		
		match inst.body_node:
			0: ## Label
				child_node = Label.new()
				child_node.horizontal_alignment = LABEL_HORIZONTAL_ALIGNMENT
				
				child_node.text = inst.title_instr
				new_node.add_child(child_node)
			
			1: ## SpinBox
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
					active_node.value = 0
			
			2: ## TextEdit
				active_node = TextEdit.new()
				
				active_node.scroll_fit_content_height = TEXT_FIT_CONTENT_HEIGHT
				active_node.scroll_fit_content_width = TEXT_FIT_CONTENT_WIDTH
				active_node.custom_minimum_size.x = TEXT_MINIMUM_SIZE_X
				
				child_node = HBoxContainer.new()
				
				new_node.add_child(child_node)
				var label = Label.new()
				label.text = inst.title_instr
				child_node.add_child(label)
				child_node.add_child(active_node)
				if inst.body_value != null:
					active_node.text = inst.body_value
				else:
					active_node.text = ""
		
		new_node.set_slot(ind,inst.is_left,inst.left_type,inst.left_color,inst.is_right,inst.right_type,inst.right_color)
		
		var metadata = GraphNodeMetadata.new()
		metadata.instr = inst
		central_ports_data_ar.append(metadata)
		
		if inst.is_left == true:
			metadata.port_num = left_port_mum
			left_ports_data_ar.append(metadata)
			
			left_port_mum += 1
			
		if inst.is_right == true:
			metadata.port_num = right_port_mum
			right_ports_data_ar.append(metadata)
			
			right_port_mum += 1
		
		child_node.set_meta(ACTIVE_NODE_DATA_NAME,active_node)
		
		ind += 1
	
	new_node.set_meta(BIG_INSTR_NODE_DATA_NAME,big_instr)
	
	new_node.set_meta(CENTRAL_PORTS_DATA_NAME,central_ports_data_ar)
	new_node.set_meta(LEFT_PORTS_DATA_NAME,left_ports_data_ar)
	new_node.set_meta(RIGHT_PORTS_DATA_NAME,right_ports_data_ar)
	
	graph_edit.add_child(new_node)
	return new_node

## ЗАГРУЗКА SAVEGRAPH, гав гав
func LoadSaveGraph(save_graph : Dictionary) -> void:
	
	graph_edit.ClearGraphScene()
	if save_graph.is_empty():
		return
	
	## ЗАГРУЗКА НОДОВ
	
	var big_instr_to_node : Dictionary
	
	for big_instr in save_graph.keys():
		var new_node = MakeNodeFromBigInstr(big_instr)
		big_instr_to_node[big_instr] = new_node
		
	for big_instr in save_graph.keys():
		## ЗАГРУЗКА СОЕДИНЕНИЙ
		for left_port : FromToWith in save_graph[big_instr][LEFT_PORTS_DATA_NAME]:
			
			if left_port.to_obj is String:
				continue
			
			graph_edit.connect_node(
				big_instr_to_node[left_port.to_obj].name, left_port.to_data.port_num,
				big_instr_to_node[big_instr].name,left_port.from_data.port_num
				)
			
		for right_port : FromToWith in save_graph[big_instr][RIGHT_PORTS_DATA_NAME]:
			
			if right_port.to_obj is String:
				continue
			
			graph_edit.connect_node(
				big_instr_to_node[big_instr].name,right_port.from_data.port_num,
				big_instr_to_node[right_port.to_obj].name, right_port.to_data.port_num
				)
