extends Control

@onready var graph_edit: GraphEdit = $PanelContainer/VBoxContainer/GraphEdit

@export var room_set : RoomsSet
@export var gener_rule_set : GenerRuleSet

const TOOLTYPE : int = 5 ##Для передачи технических значений
const TOOLCOLOR :=  Color.WHITE

func _ready() -> void:
	
	bake_ui()
	
	
	
	var start_istr = GraphNodeMakeInsts.new()
	start_istr.title_instr = ""
	start_istr.is_right = true
	start_istr.right_type = TOOLTYPE
	start_istr.right_color = TOOLCOLOR
	make_node("Start Gener",[start_istr],0)
	
	##А нахуй он мне нужен...
	var end_istr = GraphNodeMakeInsts.new()
	end_istr.title_instr = ""
	end_istr.is_left = true
	end_istr.left_type = TOOLTYPE
	end_istr.left_color = TOOLCOLOR
	make_node("End Gener",[end_istr],0)

@onready var node_list: OptionButton = $PanelContainer/VBoxContainer/MarginContainer/HBoxContainer/NodeList

const ROOMNODENAME = "Room Node: "
const ROOMNODEINSTRNAME = "make_room"

func bake_ui() -> void:
	var free_ind : int = 0
	
	## ШТУКА С НАСТРОЙКАМИ
	## ШТУКА С ЧЕМ ТО ТАМ ЕЩЕ
	
	for room in room_set.rooms_ar.size():
		if room_set.rooms_ar[room] != null:
			
			var name_item : String = ROOMNODENAME + room_set.rooms_ar[room].name_+" "+str(room)
			node_list.add_item(name_item, free_ind)
			node_list.set_item_metadata(free_ind,[ROOMNODEINSTRNAME, room_set.rooms_ar[room], name_item])
			
			free_ind += 1

func _on_add_node_pressed() -> void:
	var sel_meta = node_list.get_selected_metadata()

	match sel_meta[0]:
		ROOMNODEINSTRNAME:
			var instr = room_to_instrgraphnode(sel_meta[1])
			make_node(sel_meta[2],instr,0) ## А ЧЕ ПО МЕТЕ, СУЧКА?


var toolconnectordirection_ar : Array[Array] = [[true,false],[false,true],[true,false],[false,true]]
var toolconnectortype_ar : Array[int] = [5,6,7]
var toolconnectorcolor_ar : Array[Color] = [Color.LIGHT_BLUE,Color.BLUE,Color.DARK_BLUE]
var toolaltconnectortype_ar : Array[int] = [8,9,10]
var toolaltconnectorcolor_ar : Array[Color] = [Color.LIGHT_GOLDENROD,Color.YELLOW,Color.DARK_KHAKI]

const DIRECTION : Array[String] = ["up","down","left","right"] 
const TYPECONNECTOR : Array[String] = ["black","white"]

func room_to_instrgraphnode(room : Room) -> Array[GraphNodeMakeInsts]:
	var insrt_ar : Array[GraphNodeMakeInsts] = []
	
	for connector : RoomConnector in room.room_connectors_ar:
		
		print(room.room_connectors_ar.size())
		
		var instr = GraphNodeMakeInsts.new()
		instr.is_left = toolconnectordirection_ar[connector.direction][0]
		instr.is_right = toolconnectordirection_ar[connector.direction][1]
		instr.title_instr = DIRECTION[connector.direction] + " " + TYPECONNECTOR[connector.type]
		
		if connector.type == 0:
			instr.left_type = toolconnectortype_ar[connector.size_]
			instr.right_type = toolconnectortype_ar[connector.size_]
			instr.left_color = toolconnectorcolor_ar[connector.size_]
			instr.right_color = toolconnectorcolor_ar[connector.size_]
		else:
			instr.left_type = toolaltconnectortype_ar[connector.size_]
			instr.right_type = toolaltconnectortype_ar[connector.size_]
			instr.left_color = toolaltconnectorcolor_ar[connector.size_]
			instr.right_color = toolaltconnectorcolor_ar[connector.size_]
		
		insrt_ar.append(instr)
	
	return insrt_ar

const CUSTOMDATANAME = "custom_data"

##inst_make - состоит из [[string,is_left,is_right,type_int,color]]
func make_node(node_name : String,inst_make : Array[GraphNodeMakeInsts],data : int) -> void:
	
	var new_node = GraphNode.new()
	new_node.set_meta(CUSTOMDATANAME,data)
	new_node.title = node_name
	
	var ind = 0
	for inst in inst_make:
		var new_label = Label.new()
		new_label.text = inst.title_instr
		new_node.add_child(new_label)
		
		new_node.set_slot(ind,inst.is_left,inst.left_type,inst.left_color,inst.is_right,inst.right_type,inst.right_color)
		
		ind += 1
	
	graph_edit.add_child(new_node)


func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if graph_edit.is_node_connected(from_node, from_port, to_node, to_port):
		graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
	else:
		graph_edit.connect_node(from_node, from_port, to_node, to_port)
