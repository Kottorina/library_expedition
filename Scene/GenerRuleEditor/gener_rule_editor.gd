extends Control

@onready var graph_edit: GraphEdit = $PanelContainer/VBoxContainer/GraphEdit

@export var room_set : RoomsSet
@export var ready_location_set_path : String

const TOOLTITLE : String = "Tool:"
const TOOLTYPE : int = 5 ##Для передачи технических значений
const TOOLCOLOR :=  Color.WHITE

var start_gener_node : Node

func _ready() -> void:
	bake_ui()
	make_start_gener_node()

@onready var node_list: OptionButton = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/NodeList

const ENTER_LOCATION_TITLE : String = "Id Enter:"
const ROOMNODENAME = "Room Node: "
const ENTER_LOCATION_NAME : String = "Enter Location Node"
const START_GENER_LOCATION_TITLE : String = "Start Gener Node"

func make_start_gener_node() -> void: ##Стартовая хуйня, без нее генерация по пизде идет
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = START_GENER_LOCATION_TITLE
	
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

	var node = make_node_from_biginstr(big_instr)
	start_gener_node = node

func bake_ui() -> void:
	bake_ui_enter_node()
	bake_ui_rooms_nodes()
var free_ind : int = -1
func get_free_ind() -> int:
	free_ind += 1
	return free_ind

func bake_ui_enter_node() -> void: ##Универсальный нод для обозначения входа на локу
	var ind = get_free_ind()
	
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.title_node = ENTER_LOCATION_NAME
	
	var instr = GraphNodeMakeInsts.new()
	instr.is_right = true 
	instr.body_node = 1
	instr.title_instr = ENTER_LOCATION_TITLE
	instr.right_type = TOOLENTERTYPE
	instr.right_color = TOOLENTERCOLOR
	
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
	
	for connector : RoomConnector in room.room_connectors_ar:
		var instr = GraphNodeMakeInsts.new()
		instr.body_node = 0
		instr.source_res = connector
		instr.title_instr = " ".join([TOOLCONNECTORTITLE, DIRECTION[connector.direction], BASECOLORTYPE[connector.type], SIZE[connector.size_]])
		
		instr.is_left = toolconnectordirection_ar[connector.direction][0]
		instr.is_right = toolconnectordirection_ar[connector.direction][1]
		instr.left_type = CONNECTORTYPEDICT[connector.type][connector.size_]
		instr.right_type = CONNECTORTYPEDICT[connector.type][connector.size_]
		instr.left_color = CONNECTORCOLORDICT[connector.type][connector.size_]
		instr.right_color = CONNECTORCOLORDICT[connector.type][connector.size_]
		big_instr.instr_ar.append(instr)
	
	for enter : RoomEnter in room.room_enter_ar:
		var instr = GraphNodeMakeInsts.new()
		instr.body_node = 0
		instr.source_res = enter
		instr.title_instr = " ".join([TOOLENTERTITLE, BASECOLORTYPE[enter.type]]) 
		
		instr.is_left = true
		instr.left_type = TOOLENTERTYPE
		instr.left_color = TOOLENTERCOLOR
		big_instr.instr_ar.append(instr)
	
	return big_instr

func _on_add_node_pressed() -> void:
	var sel_meta = node_list.get_selected_metadata()
	if sel_meta == null:
		print("node_list meta broken")
	
	make_node_from_biginstr(sel_meta)


const TYPE_NODE_DATA_NAME : String = "TypeNodeData" ## String --- Хранит тип нода, для быстрой выпечки
const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]

func make_node_from_biginstr(big_instr : BigGraphNodeMakeInsts) -> GraphNode:
	
	var new_node = GraphNode.new()
	new_node.title = big_instr.title_node
	
	var left_ports_data_ar : Array[GraphNodeMetadata] = [] ## Сам RES + active_node
	var right_ports_data_ar : Array[GraphNodeMetadata] = [] ## Сам RES + active_node
	
	var ind = 0
	for inst in big_instr.instr_ar:
		
		var active_node : Node
		match inst.body_node:
			0:
				active_node = Label.new()
				
				active_node.text = inst.title_instr
				new_node.add_child(active_node)
			1:
				active_node = SpinBox.new()
				
				var cont = HBoxContainer.new()
				new_node.add_child(cont)
				var label = Label.new()
				label.text = inst.title_instr
				cont.add_child(label)
				cont.add_child(active_node)
		
		new_node.set_slot(ind,inst.is_left,inst.left_type,inst.left_color,inst.is_right,inst.right_type,inst.right_color)
		
		if inst.is_left == true:
			var metadata = GraphNodeMetadata.new()
			metadata.source_res = inst.source_res
			metadata.active_node = active_node
			metadata.port_type = inst.left_type
			left_ports_data_ar.append(metadata)
		if inst.is_right == true:
			var metadata = GraphNodeMetadata.new()
			metadata.source_res = inst.source_res
			metadata.active_node = active_node
			metadata.port_type = inst.right_type
			right_ports_data_ar.append(metadata)
		
		ind += 1
	
	new_node.set_meta(TYPE_NODE_DATA_NAME,big_instr.type_node)
	new_node.set_meta(LEFT_PORTS_DATA_NAME,left_ports_data_ar)
	new_node.set_meta(RIGHT_PORTS_DATA_NAME,right_ports_data_ar)
	
	graph_edit.add_child(new_node)
	return new_node

var occupied_ports : Dictionary ## { node : { const l/r : { 1 : true, 3 : true... } } }

func _on_save_test_pressed() -> void:
	
	occupied_ports.clear()
	
	var current_node = start_gener_node
	
	var free_nodes : Dictionary ## { node (StringName) : true }
	free_nodes[current_node] = true
	
	var graph : Dictionary = {}
	
	## СУКА! НЕ ЗАБУДЬ ПРО ДОПОЛНИТЕЛЬНУЮ ХТОНЬ В METADATA, ДЛЯ ЗАГРУЗКИ!!!
	
	
	
	


	
	## ///...

	var right_ports : Array ## Все правые порты обьекта и их соеденения
	var right_data_meta : Array[GraphNodeMetadata] = current_node.get_meta(RIGHT_PORTS_DATA_NAME)
	for data in right_data_meta:
		right_ports.append({data : null})
	
	var left_ports : Array ## Все левые порты обьекта и их соеденения 
	var left_data_meta : Array[GraphNodeMetadata] = current_node.get_meta(LEFT_PORTS_DATA_NAME)
	for data in left_data_meta:
		left_ports.append({data : null})
	
	var connections = graph_edit.get_connection_list_from_node(current_node.name)
	for connect_line in connections:
		
		if current_node.name != connect_line["to_node"] and is_port_block(current_node.name,connect_line["from_port"],RIGHT_PORTS_DATA_NAME) == false:
			
			var to_left_metadata = graph_edit.get_node( NodePath(connect_line["to_node"]) ).get_meta(LEFT_PORTS_DATA_NAME)
			var final_meta = to_left_metadata[connect_line["to_port"]]
			
			var key_right = right_ports[connect_line["from_port"]].keys()[0]
			right_ports[connect_line["from_port"]][key_right] = { [final_meta] : connect_line["to_node"] }
			
			free_nodes[ NodePath(connect_line["to_node"]) ] = true
			block_port(connect_line["to_node"],connect_line["to_port"],LEFT_PORTS_DATA_NAME)
			
		
		if current_node.name != connect_line["from_node"] and  is_port_block(current_node.name,connect_line["to_port"],LEFT_PORTS_DATA_NAME) == false:
		#if ! occupied_nodes.has(connect_line["from_node"]) :
			
			var to_right_metadata = graph_edit.get_node( NodePath(connect_line["from_node"]) ).get_meta(RIGHT_PORTS_DATA_NAME)
			var final_meta = to_right_metadata[connect_line["from_port"]]
			
			var key_left = left_ports[connect_line["to_port"]].keys()[0]
			left_ports[connect_line["to_port"]][key_left] = { [final_meta] : connect_line["from_node"] }
			
			free_nodes[ NodePath(connect_line["from_node"]) ] = true
			block_port(connect_line["from_node"],connect_line["from_port"],RIGHT_PORTS_DATA_NAME)
	
	free_nodes.erase(current_node)
	
	## ///...
	
	graph[current_node.name] = { LEFT_PORTS_DATA_NAME : left_ports, RIGHT_PORTS_DATA_NAME : right_ports}
	
	print("\n".join([ graph, occupied_ports, free_nodes])) ##graph

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

		#var left_data_meta = current_node.get_meta(LEFT_PORTS_DATA_NAME)
		#for ports in left_data_meta
			#pass
			#free_nodes[connect_line["from_node"]] = 0
		#elif current_node.name != connect_line["to_node"]:
			#free_nodes[connect_line["to_node"]] = 0
				##if right_data_meta.has connect_line["from_port"]
	# [{ "from_node": &"@GraphNode@53", "from_port": 1, "to_node": &"@GraphNode@67", "to_port": 0, "keep_alive": false }]
	
	

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
