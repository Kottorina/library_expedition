extends Control

@onready var graph_edit: GraphEdit = $PanelContainer/VBoxContainer/GraphEdit

var room_set : RoomsSet

@export var room_set_path : String
@export var ready_location_set_path : String

@export var custom_big_instr_ar : Array[BigGraphNodeMakeInsts]

const TOOLTITLE : String = "Tool:"
const TOOLTYPE : int = 5 ##Для передачи технических значений
const TOOLCOLOR :=  Color.WHITE

func _ready() -> void:
	
	room_set = ResourceLoader.load(room_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
	
	bake_ui()

@onready var node_list: OptionButton = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/NodeList

const ENTER_LOCATION_TITLE : String = "Id Enter:"
const ROOMNODENAME = "Room Node: "
const ENTER_LOCATION_NAME : String = "Enter Location Node"
const START_GENER_LOCATION_TITLE : String = "Start Gener Node"

func bake_ui_start_gener_node() -> void: ##Стартовая хуйня, без нее генерация по пизде идет
	var ind = get_free_ind()
	
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = START_GENER_LOCATION_TITLE
	big_instr.type_node = 2
	
	var tool_instr = GraphNodeMakeInsts.new()
	tool_instr.title_instr = TOOLTITLE
	tool_instr.is_right = true
	tool_instr.right_type = TOOLTYPE
	tool_instr.right_color = TOOLCOLOR
	big_instr.instr_ar.append(tool_instr)
	
	var enter_instr = GraphNodeMakeInsts.new()
	enter_instr.is_right = true 
	enter_instr.body_node = 1
	enter_instr.title_instr = ENTER_LOCATION_TITLE
	enter_instr.right_type = TOOLENTERTYPE
	enter_instr.right_color = TOOLENTERCOLOR
	big_instr.instr_ar.append(enter_instr)
	
	node_list.add_item(START_GENER_LOCATION_TITLE, ind)
	node_list.set_item_metadata(ind,big_instr)

const CONNECTOR_TYPE_COUNT = 3
const CONNECTOR_DIRECTION_COUNT = 4
const CONNECTOR_SIZE_COUNT = 3

const CONNECTORS_PLUGS_TITLE : String = "Connectors Plugs Node"

func bake_ui_connectors_plugs() -> void:
	var ind = get_free_ind()
	
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = CONNECTORS_PLUGS_TITLE
	big_instr.type_node = 4
	
	var tool_instr = GraphNodeMakeInsts.new()
	tool_instr.title_instr = TOOLTITLE
	tool_instr.is_right = true
	tool_instr.right_type = TOOLTYPE
	tool_instr.right_color = TOOLCOLOR
	tool_instr.is_left = true
	tool_instr.left_type = TOOLTYPE
	tool_instr.left_color = TOOLCOLOR
	big_instr.instr_ar.append(tool_instr)
	
	for size_ in CONNECTOR_SIZE_COUNT:
		for type_ in CONNECTOR_TYPE_COUNT:
			for direction_ in CONNECTOR_DIRECTION_COUNT:
				var connector := RoomConnector.new()
				connector.type = type_
				connector.direction = direction_
				connector.size_ = size_
				big_instr.instr_ar.append(make_inst_from_connector(connector))

	node_list.add_item(CONNECTORS_PLUGS_TITLE, ind)
	node_list.set_item_metadata(ind,big_instr)

func bake_ui() -> void:
	## BAKE ВРЕМЕННАЯ КОНСТРУКЦИЯ, НЕТ ВРЕМЕНИ НА НОРМАЛЬНУЮ РЕАЛИЗАЦИЮ
	bake_ui_start_gener_node()
	bake_ui_enter_node()
	bake_ui_connectors_plugs()
	for big_instr in custom_big_instr_ar:
		var ind = get_free_ind()
		node_list.add_item(big_instr.title_node, ind)
		node_list.set_item_metadata(ind,big_instr)
	
	bake_ui_rooms_nodes()
var free_ind : int = -1
func get_free_ind() -> int:
	free_ind += 1
	return free_ind

func bake_ui_enter_node() -> void: ##Универсальный нод для обозначения входа на локу
	var ind = get_free_ind()
	
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ENTER_LOCATION_NAME
	big_instr.type_node = 1
	
	var instr = GraphNodeMakeInsts.new()
	instr.body_node = 1
	instr.title_instr = ENTER_LOCATION_TITLE
	
	
	instr.is_right = true 
	instr.right_type = TOOLENTERTYPE
	instr.right_color = TOOLENTERCOLOR
	instr.is_left = true
	instr.left_type = TOOLENTERTYPE
	instr.left_color = TOOLENTERCOLOR
	
	big_instr.instr_ar.append(instr)
	
	node_list.add_item(ENTER_LOCATION_NAME, ind)
	node_list.set_item_metadata(ind,big_instr)

func bake_ui_rooms_nodes() -> void:
	for room_ind in room_set.rooms_ar.size():
		
		var current_room = room_set.rooms_ar[room_ind]
		
		if room_set.rooms_ar[room_ind] != null:
			var ind = get_free_ind()
			var name_item : String = ROOMNODENAME + current_room.name_+" "+str(room_ind)
			
			var big_instr = room_to_biginstrgraphnode(current_room)
			big_instr.title_node = name_item
			big_instr.room_ = current_room
			
			node_list.add_item(name_item, ind)
			node_list.set_item_metadata(ind,big_instr)
	#make_node(sel_meta[2],[instr])

var toolconnectordirection_ar : Array[Array] = [[true,false],[false,true],[true,false],[false,true]]
const DIRECTION : Array[String] = ["up","down","left","right"] 
const BASECOLORTYPE : Array[String] = ["black","gray","white"]
const SIZE : Array[String] = ["tiny","small","medium","large"]

const TOOLCONNECTORTITLE : String = "Connector:"
const CONNECTORTYPEDICT : Dictionary = {
0 : [5,6,7,8],
1 : [9,10,11,12],
2 : [13,14,15,16]
}
var CONNECTORCOLORDICT : Dictionary = {
0 : [Color.LIGHT_BLUE,Color.BLUE,Color.DARK_BLUE],
1 : [Color.LIGHT_GOLDENROD,Color.YELLOW,Color.DARK_KHAKI],
2 : [Color.LIGHT_CORAL,Color.RED,Color.DARK_RED]
}
const TOOLENTERTITLE : String = "Enter:"
const TOOLENTERTYPE : int = 17
const TOOLENTERCOLOR : Color = Color.PURPLE

func room_to_biginstrgraphnode(room : Room) -> BigGraphNodeMakeInsts:
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.room_ = room
	
	for connector : RoomConnector in room.room_connectors_ar:

		big_instr.instr_ar.append(make_inst_from_connector(connector))
	
	for enter : RoomEnter in room.room_enter_ar:
		var instr = GraphNodeMakeInsts.new()
		instr.body_node = 0
		instr.source_res = enter
		instr.title_instr = " ".join([TOOLENTERTITLE, BASECOLORTYPE[enter.type]]) 
		
		instr.is_left = true
		instr.left_type = TOOLENTERTYPE
		instr.left_color = TOOLENTERCOLOR
		instr.is_right = true
		instr.right_type = TOOLENTERTYPE
		instr.right_color = TOOLENTERCOLOR
		
		big_instr.instr_ar.append(instr)
	
	return big_instr

func make_inst_from_connector(connector : RoomConnector ) -> GraphNodeMakeInsts:
	var instr := GraphNodeMakeInsts.new()

	instr.body_node = 0
	instr.source_res = connector
	instr.title_instr = " ".join([TOOLCONNECTORTITLE, DIRECTION[connector.direction], BASECOLORTYPE[connector.type], SIZE[connector.size_]])
	
	instr.is_left = toolconnectordirection_ar[connector.direction][0]
	instr.is_right = toolconnectordirection_ar[connector.direction][1]
	instr.left_type = CONNECTORTYPEDICT[connector.type][connector.size_]
	instr.right_type = CONNECTORTYPEDICT[connector.type][connector.size_]
	instr.left_color = CONNECTORCOLORDICT[connector.type][connector.size_]
	instr.right_color = CONNECTORCOLORDICT[connector.type][connector.size_]
	
	return instr

func _on_add_node_pressed() -> void:
	var sel_meta = node_list.get_selected_metadata()
	if sel_meta == null:
		print("node_list meta broken")
	
	make_node_from_biginstr(sel_meta)

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
