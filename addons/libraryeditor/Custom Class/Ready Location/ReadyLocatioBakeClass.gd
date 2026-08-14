extends Node
class_name ReadyLocationBake

const PORT_VALUE_FREE : String = "PortFree"
const PORT_VALUE_OCCUPIED : String = "PortOccupied"

const BIG_INSTR_NODE_DATA_NAME : String = "BigInstrNodeData" ## String --- Хранит тип нода, для быстрой выпечки
const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]
const ACTIVE_NODE_DATA_NAME  : String  = "ActiveNode" 

var room_graph : Dictionary
var enters_location : Dictionary
var connection_plugs_instr : BigGraphNodeMakeInsts

func bake_ready_location(ready_location : ReadyLocation, c_seed : int = 0) -> ReadyLocation:
	var new_ready_location = ready_location.duplicate()
	
	var save_graph = new_ready_location.save_graph
	var full_graph = new_ready_location.full_graph
	
	var rnd = RandomNumberGenerator.new()
	rnd.seed = c_seed
	
	room_graph.clear()
	enters_location.clear()
	
	for node_instr : BigGraphNodeMakeInsts in save_graph: 
		match node_instr.type_node:
			4:
				connection_plugs_instr = node_instr 
	
	for nodes : BigGraphNodeMakeInsts in save_graph: 
		match nodes.type_node:
			0: ## ОБРАБОТКА ПОРТОВ У MAKEROOM
				for left_port : Dictionary in save_graph[nodes][LEFT_PORTS_DATA_NAME]:
					room_bake_not_free_port(save_graph,nodes,left_port,LEFT_PORTS_DATA_NAME)
					room_bake_free_port(save_graph,nodes,left_port,LEFT_PORTS_DATA_NAME)
				
				## ДЛЯ ПРАВЫХ ПОРТОВ, НАХУЙ ФАШИСТОВ
				for right_port : Dictionary in save_graph[nodes][RIGHT_PORTS_DATA_NAME]:
					room_bake_not_free_port(save_graph,nodes,right_port,RIGHT_PORTS_DATA_NAME)
					room_bake_free_port(save_graph,nodes,right_port,RIGHT_PORTS_DATA_NAME)

			2:  ## ОБРАБОТКА СТРАТОВОГО НОДА ОТДЕЛЬНО и ТОЛЬКО СУКА ПРАВЫЕ
				for right_port : Dictionary in save_graph[nodes][RIGHT_PORTS_DATA_NAME]:
					## ОБРАБОТКА ГОТОВЫХ ПОРТОВ
					if right_port[right_port.keys()[0]] is Array:
						## Запекаем готовый порт
						var to_port_meta : GraphNodeMetadata = right_port[right_port.keys()[0]][0]
						var to_node_instr : BigGraphNodeMakeInsts = right_port[right_port.keys()[0]][1]
						
						if to_port_meta.source_res is RoomEnter:
							
							var from_port_meta = right_port.keys()[0]
							
							var value = from_port_meta.active_node.value
							var enter : RoomEnter = to_port_meta.source_res
							
							enters_location[enter] = value
	
			5:
				
				var enter_ports : Array 
				var exit_ports : Array 
				var const_port_direction : String
				var setting_biginstr : BigGraphNodeMakeInsts = null
				
				var left_ports  = full_graph[nodes][LEFT_PORTS_DATA_NAME]
				for left_port : Dictionary in left_ports:
					if ! left_port.keys()[0].source_res is RoomConnector:
						left_ports.erase(left_port)
						if ! left_port[left_port.keys()[0]] is String:
							if left_port[left_port.keys()[0]][1].type_node == 6:
								setting_biginstr = left_port[left_port.keys()[0]][1]
				var right_ports = full_graph[nodes][RIGHT_PORTS_DATA_NAME]
				for right_port : Dictionary in right_ports:
					if ! right_port.keys()[0].source_res is RoomConnector:
						right_ports.erase(right_port)
						if ! right_port[right_port.keys()[0]] is String:
							if right_port[right_port.keys()[0]][1].type_node == 6:
								setting_biginstr = right_port[right_port.keys()[0]][1]
				
				if setting_biginstr == null:
					
					## ПОДКЛЮЧИ К BASE, СУЧКА
					
					continue
				
				if left_ports.size() > right_ports.size():
					enter_ports = right_ports
					exit_ports = left_ports
					const_port_direction = RIGHT_PORTS_DATA_NAME
				else:
					enter_ports = left_ports
					exit_ports = right_ports
					const_port_direction =  LEFT_PORTS_DATA_NAME
				
				for port_id in exit_ports.size():
					port_id += 1 ## ТАК НАДО, НЕ ТРОГАТЬ, ГАВ
					if setting_biginstr.instr_ar.size() <= port_id:
						continue
					
					if rnd.randf_range(0,1) < setting_biginstr.instr_ar[port_id].body_value:
						print("Port use: ",str(port_id))
						
						bake_con_to_con(
							save_graph,
							enter_ports[0][enter_ports[0].keys()[0]][0],
							enter_ports[0][enter_ports[0].keys()[0]][1],
							exit_ports[port_id][exit_ports[port_id].keys()[0]][0],
							exit_ports[port_id][exit_ports[port_id].keys()[0]][1],
							const_port_direction
							)
				
				#print(enter_ports,"\n\n",exit_ports)
				
					#fork_bake_free_port(save_graph,nodes,left_port,LEFT_PORTS_DATA_NAME)
				#for right_port : Dictionary in save_graph[nodes][RIGHT_PORTS_DATA_NAME]:
					#fork_bake_not_free_port(save_graph,nodes,right_port,RIGHT_PORTS_DATA_NAME)
					#fork_bake_free_port(save_graph,nodes,right_port,RIGHT_PORTS_DATA_NAME)
				
	new_ready_location.rooms_graph = room_graph
	new_ready_location.enters_location = enters_location
	
	return new_ready_location

## КОМНАТЫ ОБРАБОТКА ГОТОВЫХ ПОРТОВ
func room_bake_not_free_port(save_graph : Dictionary, from_node_instr : BigGraphNodeMakeInsts , port, const_name : String) -> void:
	if ! port[port.keys()[0]] is Array:
		return
	var from_meta = port.keys()[0]
	var to_port_meta : GraphNodeMetadata = port[port.keys()[0]][0]
	var to_node_instr : BigGraphNodeMakeInsts = port[port.keys()[0]][1]
	bake_con_to_con(save_graph,from_meta,from_node_instr,to_port_meta,to_node_instr,const_name)

func bake_con_to_con(
	save_graph : Dictionary,from_meta : GraphNodeMetadata, from_node_instr : BigGraphNodeMakeInsts, to_port_meta : GraphNodeMetadata, to_node_instr : BigGraphNodeMakeInsts , const_name : String
	) -> void:
	if to_node_instr.type_node == 0 and to_port_meta.source_res is RoomConnector:
		
		var new_co_to_con := new_con_to_con(
		from_meta.source_res,to_port_meta.source_res,to_node_instr.room_)
		if room_graph.has(from_node_instr.room_):
			room_graph[from_node_instr.room_].append(new_co_to_con)
		else:
			room_graph[from_node_instr.room_] = [new_co_to_con]
		
	elif to_node_instr.type_node == 1:
		
		var value = to_port_meta.active_node.value
		var enter : RoomEnter = save_graph[from_node_instr][const_name][to_port_meta.port_num].keys()[0].source_res
		
		enters_location[enter] = value

## КОМНАТЫ ОБРАБОТКА СВОБОДНЫХ ПОРТОВ
func room_bake_free_port(save_graph : Dictionary, from_node_instr : BigGraphNodeMakeInsts , port, const_name : String) -> void:
	if port[port.keys()[0]] is Array:
		return
	if ! port.keys()[0].source_res is RoomConnector or ! port[port.keys()[0]] == PORT_VALUE_FREE:
		return
	
	for plugs_ports in save_graph[connection_plugs_instr][const_name]:
		var meta = plugs_ports.keys()[0]
		if meta.source_res is RoomConnector:
								
			if is_connectors_identical(port.keys()[0].source_res,meta.source_res) == true:
									
				var plug_big_instr = save_graph[connection_plugs_instr][const_name][meta.port_num]
				var key = save_graph[connection_plugs_instr][const_name][meta.port_num].keys()[0]
									
				if plug_big_instr[key] is String:
					continue
					
				var new_co_to_con := new_con_to_con(
				port.keys()[0].source_res,plug_big_instr[key][0].source_res,plug_big_instr[key][1].room_)
				if room_graph.has(from_node_instr.room_):
					room_graph[from_node_instr.room_].append(new_co_to_con)
				else:
					room_graph[from_node_instr.room_] = [new_co_to_con]

func new_con_to_con(from_con : RoomConnector,to_con : RoomConnector,to_room : Room) -> ConnectorToConnector:
	var con_to_con := ConnectorToConnector.new()
	con_to_con.from_connector = from_con
	con_to_con.to_connector = to_con
	con_to_con.to_room = to_room
	
	return con_to_con

const directio_oppisite = {0 : 1 , 1 : 0 , 2 : 3 , 3 : 2 }

func is_connectors_opposite(connector_one : RoomConnector, connector_two : RoomConnector) -> bool: ## РАСШИРЬ ЕСЛИ ЧЕТО СДЕЛАЕЬ С КОННЕКТОРОМ БЛЯДЬ
	if directio_oppisite[connector_one.direction] == connector_two.direction:
		
		if connector_one.size_ == connector_two.size_ and connector_one.type == connector_two.type:
			return true
	return false

func is_connectors_identical(connector_one : RoomConnector, connector_two : RoomConnector) -> bool: ## РАСШИРЬ ЕСЛИ ЧЕТО СДЕЛАЕЬ С КОННЕКТОРОМ БЛЯДЬ
	if connector_one.direction == connector_two.direction and connector_one.size_ == connector_two.size_ and connector_one.type == connector_two.type:
		return true
	return false
