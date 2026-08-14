extends Node

@export var node_tool_room : Control

@export var custom_big_instr_ar : Array[BigGraphNodeMakeInsts]

const TOOLTITLE : String = "Tool:"
const TOOLTYPE : int = 5 ##Для передачи технических значений
const TOOLCOLOR :=  Color.WHITE

const TOOL_FORK_UI_NAME : String = "Tool Fork"
const TOOL_UI_NAME : String = "Tool"
const ROOMS_UI_NAME : String = "Rooms"

const ENTER_LOCATION_TITLE : String = "Id Enter:"
const ROOMNODENAME = "Room Node: "
const ENTER_LOCATION_NAME : String = "Enter Location Node"
const START_GENER_LOCATION_TITLE : String = "Start Gener Node"

const BIG_RND_FORK_TITLE : String = "Rnd Fork"
const INSTR_FORK_BASE_TITLE : String = "Base Option: "
const INSTR_FORK_ALT_CHANCE_TITLE : String = "Alt Chance: "

const CONNECTOR_TYPE_COUNT = 3
const CONNECTOR_DIRECTION_COUNT = 4
const CONNECTOR_SIZE_COUNT = 3

var toolconnectordirection_ar : Array[Array] = [[true,false],[false,true],[true,false],[false,true]]
const DIRECTION : Array[String] = ["up","down","left","right"] 
const DIRECTION_INVERT : Array[int] = [1,0,3,2] 

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

var room_set : RoomsSet
@export var room_set_path : String

func _ready() -> void:
	_on_bake_node_pressed()
func _on_bake_node_pressed() -> void:
	room_set = ResourceLoader.load(room_set_path,"",ResourceLoader.CACHE_MODE_IGNORE)
	bake_ui()

func bake_ui() -> void:
	bake_ui_all_rnd_fork()
	bake_ui_start_gener_node()
	bake_custom_big_instr()
	bake_ui_connectors_plugs()
	bake_ui_enter_node()
	
	bake_ui_rooms_nodes()

func bake_ui_rooms_nodes() -> void:
	for room_ind in room_set.rooms_ar.size():
		
		var current_room = room_set.rooms_ar[room_ind]
		
		if room_set.rooms_ar[room_ind] != null:
			var name_item : String = ROOMNODENAME + current_room.name_+" "+str(room_ind)
			
			var big_instr = room_to_biginstrgraphnode(current_room)
			big_instr.title_node = name_item
			big_instr.room_ = current_room
			
			node_tool_room.add_new_item(ROOMS_UI_NAME, big_instr)

func bake_ui_enter_node() -> void: ##Универсальный нод для обозначения входа на локу
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
	
	node_tool_room.add_new_item(TOOL_UI_NAME, big_instr)

const CONNECTORS_PLUGS_TITLE : String = "Connectors Plugs Node"
func bake_ui_connectors_plugs() -> void:
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

	node_tool_room.add_new_item(TOOL_UI_NAME, big_instr)

func bake_custom_big_instr() -> void:
	for big_instr in custom_big_instr_ar:
		node_tool_room.add_new_item(big_instr.ui_category, big_instr)

func bake_ui_start_gener_node() -> void: ##Стартовая хуйня, без нее генерация по пизде идет
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
	
	node_tool_room.add_new_item(TOOL_UI_NAME, big_instr)

func bake_ui_all_rnd_fork() -> void: ## Случайные Перекрестки, Очень Круто
	for type_ in CONNECTOR_TYPE_COUNT:
		for size_ in CONNECTOR_SIZE_COUNT:
			for direction_ in CONNECTOR_DIRECTION_COUNT:
				var connector := RoomConnector.new()
				connector.type = type_
				connector.direction = direction_
				connector.size_ = size_
				bake_ui_rnd_fork_from_connector(connector)

func bake_ui_rnd_fork_from_connector( enter_connector : RoomConnector ) -> void: ## Случайные Перекрестки, Очень Круто
	var big_instr = BigGraphNodeMakeInsts.new()
	big_instr.type_node = 5
	
	var tool_instr = GraphNodeMakeInsts.new()
	tool_instr.title_instr = TOOLTITLE
	tool_instr.is_right = true
	tool_instr.right_type = TOOLTYPE
	tool_instr.right_color = TOOLCOLOR
	tool_instr.is_left = true
	tool_instr.left_type = TOOLTYPE
	tool_instr.left_color = TOOLCOLOR
	big_instr.instr_ar.append(tool_instr)
	
	var enter_instr = make_inst_from_connector(enter_connector)
	big_instr.instr_ar.append(enter_instr)
	
	var big_title = BIG_RND_FORK_TITLE + " " + enter_instr.title_instr
	
	big_instr.title_node = big_title
	
	var exit_connector = enter_connector.duplicate()
	exit_connector.direction = DIRECTION_INVERT[enter_connector.direction]
	var exit_instr_one = make_inst_from_connector(exit_connector)
	exit_instr_one.title_instr = INSTR_FORK_BASE_TITLE
	big_instr.instr_ar.append(exit_instr_one)
	
	var exit_instr_two = make_inst_from_connector(exit_connector)
	exit_instr_two.body_node = 1
	exit_instr_two.title_instr = INSTR_FORK_ALT_CHANCE_TITLE
	big_instr.instr_ar.append(exit_instr_two)
	
	node_tool_room.add_new_item(TOOL_FORK_UI_NAME, big_instr)

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
