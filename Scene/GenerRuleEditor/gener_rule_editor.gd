extends Control

@onready var graph_edit: GraphEdit = $PanelContainer/VBoxContainer/GraphEdit

@export var room_set : RoomsSet
@export var gener_rule_set : GenerRuleSet

const TOOLTYPE : int = 5 ##Для передачи технических значений
const TOOLCOLOR :=  Color.WHITE

func _ready() -> void:
	
	bake_ui()
	
	return

@onready var node_list: OptionButton = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/NodeList

const ROOMNODENAME = "Room Node: "
const ROOMNODEINSTRNAME = "make_room"

const ENTER_LOCATION_NAME : String = "Enter Location Node"
const ENTER_LOCATION_TITLE : String = "Id Enter:"
const ENTER_LOCATION_INSTR : String = "enter_location"

func bake_ui() -> void:
	
	
	## ШТУКА С НАСТРОЙКАМИ
	## ШТУКА С ЧЕМ ТО ТАМ ЕЩЕ
	
	##Нод для входа на локацию
	var ind = get_free_ind()
	node_list.add_item(ENTER_LOCATION_NAME, ind)
	node_list.set_item_metadata(ind,[ENTER_LOCATION_INSTR,null,ENTER_LOCATION_NAME])
	
	##Инициализация комнат из roomset
	for room in room_set.rooms_ar.size():
		if room_set.rooms_ar[room] != null:
			ind = get_free_ind()
			var name_item : String = ROOMNODENAME + room_set.rooms_ar[room].name_+" "+str(room)
			node_list.add_item(name_item, ind)
			node_list.set_item_metadata(ind,[ROOMNODEINSTRNAME, room_set.rooms_ar[room], name_item])

var free_ind : int = -1
func get_free_ind() -> int:
	free_ind += 1
	return free_ind

func _on_add_node_pressed() -> void:
	var sel_meta = node_list.get_selected_metadata()
	if sel_meta == null:
		print("FUCK bake_ui IS BROKEN(((")
	
	match sel_meta[0]:
		ROOMNODEINSTRNAME:
			var instr = room_to_instrgraphnode(sel_meta[1])
			make_node(sel_meta[2],instr) ## А ЧЕ ПО МЕТЕ, СУЧКА?
		ENTER_LOCATION_INSTR:
			var instr = GraphNodeMakeInsts.new()
			instr.is_right = true 
			instr.body_node = 1
			instr.title_instr = ENTER_LOCATION_TITLE
			instr.right_type = TOOLENTERTYPE
			instr.right_color = TOOLENTERCOLOR
			make_node(sel_meta[2],[instr])


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

func room_to_instrgraphnode(room : Room) -> Array[GraphNodeMakeInsts]:
	var insrt_ar : Array[GraphNodeMakeInsts] = []
	
	for connector : RoomConnector in room.room_connectors_ar:
		var instr = GraphNodeMakeInsts.new()
		instr.body_node = 0
		instr.title_instr = " ".join([TOOLCONNECTORTITLE, DIRECTION[connector.direction], BASECOLORTYPE[connector.type], SIZE[connector.size_]])
		
		instr.is_left = toolconnectordirection_ar[connector.direction][0]
		instr.is_right = toolconnectordirection_ar[connector.direction][1]
		instr.left_type = CONNECTORTYPEDICT[connector.type][connector.size_]
		instr.right_type = CONNECTORTYPEDICT[connector.type][connector.size_]
		instr.left_color = CONNECTORCOLORDICT[connector.type][connector.size_]
		instr.right_color = CONNECTORCOLORDICT[connector.type][connector.size_]
		insrt_ar.append(instr)
	for enter : RoomEnter in room.room_enter_ar:
		var instr = GraphNodeMakeInsts.new()
		instr.body_node = 0
		instr.title_instr = " ".join([TOOLENTERTITLE, BASECOLORTYPE[enter.type]]) 
		
		instr.is_left = true
		instr.left_type = TOOLENTERTYPE
		instr.left_color = TOOLENTERCOLOR
		insrt_ar.append(instr)
	
	return insrt_ar

const CUSTOMDATANAME = "custom_data"

##inst_make - состоит из [[string,is_left,is_right,type_int,color]]
func make_node(node_name : String,inst_make : Array[GraphNodeMakeInsts]) -> void:
	
	var new_node = GraphNode.new()
	#new_node.set_meta(CUSTOMDATANAME,data)
	new_node.title = node_name
	
	var ind = 0
	for inst in inst_make:
		
		match inst.body_node:
			0:
				var child_node : Node
				child_node = Label.new()
				child_node.text = inst.title_instr
				new_node.add_child(child_node)
			1:
				var cont = HBoxContainer.new()
				new_node.add_child(cont)
				var label = Label.new()
				label.text = inst.title_instr
				var spin_box = SpinBox.new()
				cont.add_child(label)
				cont.add_child(spin_box)
				
		
		
		new_node.set_slot(ind,inst.is_left,inst.left_type,inst.left_color,inst.is_right,inst.right_type,inst.right_color)
		
		ind += 1
	
	graph_edit.add_child(new_node)



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
