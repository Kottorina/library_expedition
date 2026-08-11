extends Node
class_name ReadyLocationBake

const PORT_VALUE_FREE : String = "PortFree"
const PORT_VALUE_OCCUPIED : String = "PortOccupied"

const BIG_INSTR_NODE_DATA_NAME : String = "BigInstrNodeData" ## String --- Хранит тип нода, для быстрой выпечки
const LEFT_PORTS_DATA_NAME  : String  = "LeftPortsData" ## Array[Metadata...]
const RIGHT_PORTS_DATA_NAME  : String  = "RightPortsData" ## Array[Metadata...]
const ACTIVE_NODE_DATA_NAME  : String  = "ActiveNode" 

func bake_ready_location(ready_location : ReadyLocation) -> ReadyLocation:
	var new_ready_location = ready_location
	var save_graph = new_ready_location.save_graph
	var connection_plugs_instr = new_ready_location.connection_plugs_instr
	
	var room_graph : Dictionary
	var enters_location : Dictionary
	
	## Обработка Открытых Портов И Переходов Между Локациями
	
	## ДА ОНО НЕ РАБОТАЕТ С РАНДОМОМ, А ДОЛЖНО БЛЯДЬ
	
	for nodes : BigGraphNodeMakeInsts in save_graph: 
		match nodes.type_node:
			0:
				#print(nodes," ",nodes.room_,"\n",room_graph)
				
				for left_port : Dictionary in save_graph[nodes][LEFT_PORTS_DATA_NAME]:
					
					## ОБРАБОТКА ГОТОВЫХ ПОРТОВ
					if left_port[left_port.keys()[0]] is Array: 
						## Запекаем готовый порт
						var to_port_meta : GraphNodeMetadata = left_port[left_port.keys()[0]][0]
						var to_node_instr : BigGraphNodeMakeInsts = left_port[left_port.keys()[0]][1]
						if to_node_instr.type_node == 0 and to_port_meta.source_res is RoomConnector:
							
							var new_co_to_con := new_con_to_con(
								left_port.keys()[0].source_res,to_port_meta.source_res,left_port[left_port.keys()[0]][1].room_
								)
							if room_graph.has(nodes.room_):
								room_graph[nodes.room_].append(new_co_to_con)
							else:
								room_graph[nodes.room_] = [new_co_to_con]
						
						elif to_node_instr.type_node == 1:
							var value = to_port_meta.active_node.value
							var enter : RoomEnter = save_graph[nodes][LEFT_PORTS_DATA_NAME][to_port_meta.port_num].keys()[0].source_res
							
							enters_location[enter] = value
							
						continue
					
					if left_port.keys()[0].source_res is RoomConnector and left_port[left_port.keys()[0]] == PORT_VALUE_FREE:
						
						## В таком случае ищем заглушку в connector plugs node
						for right_ports in save_graph[connection_plugs_instr][LEFT_PORTS_DATA_NAME]:
							
							var meta = right_ports.keys()[0]
							if meta.source_res is RoomConnector:
								
								## ОБРАБОТКА НЕ ПОЛНАЯ
								
								if is_connectors_identical(left_port.keys()[0].source_res,meta.source_res) == true:
									
									var plug_big_instr = save_graph[connection_plugs_instr][LEFT_PORTS_DATA_NAME][meta.port_num]
									var key = save_graph[connection_plugs_instr][LEFT_PORTS_DATA_NAME][meta.port_num].keys()[0]
									
									if plug_big_instr[key] is String:
										continue
									
									var new_co_to_con := new_con_to_con(
										left_port.keys()[0].source_res,plug_big_instr[key][0].source_res,plug_big_instr[key][1].room_
										)
									if room_graph.has(nodes.room_):
										room_graph[nodes.room_].append(new_co_to_con)
									else:
										room_graph[nodes.room_] = [new_co_to_con]
				
				## ДЛЯ ПРАВЫХ ПОРТОВ, НАХУЙ ФАШИСТОВ
				
				for right_port : Dictionary in save_graph[nodes][RIGHT_PORTS_DATA_NAME]:
					
					## ОБРАБОТКА ГОТОВЫХ ПОРТОВ
					if right_port[right_port.keys()[0]] is Array:
						## Запекаем готовый порт
						var to_port_meta : GraphNodeMetadata = right_port[right_port.keys()[0]][0]
						var to_node_instr : BigGraphNodeMakeInsts = right_port[right_port.keys()[0]][1]
						
						if to_node_instr.type_node == 0 and to_port_meta.source_res is RoomConnector:
							
							var new_co_to_con := new_con_to_con(
								right_port.keys()[0].source_res,to_port_meta.source_res,right_port[right_port.keys()[0]][1].room_
								)
							if room_graph.has(nodes.room_):
								room_graph[nodes.room_].append(new_co_to_con)
							else:
								room_graph[nodes.room_] = [new_co_to_con]
						
						elif to_node_instr.type_node == 1:
							
							var value = to_port_meta.active_node.value
							var enter : RoomEnter = save_graph[nodes][RIGHT_PORTS_DATA_NAME][to_port_meta.port_num].keys()[0].source_res
							
							enters_location[enter] = value
						
						continue
					
					if right_port.keys()[0].source_res is RoomConnector and right_port[right_port.keys()[0]] == PORT_VALUE_FREE:
						
						## В таком случае ищем заглушку в connector plugs node
						for right_ports in save_graph[connection_plugs_instr][RIGHT_PORTS_DATA_NAME]:
							
							var meta = right_ports.keys()[0]
							if meta.source_res is RoomConnector:
								
								## ОБРАБОТКА НЕ ПОЛНАЯ
								
								if is_connectors_identical(right_port.keys()[0].source_res,meta.source_res) == true:
									
									var plug_big_instr = save_graph[connection_plugs_instr][RIGHT_PORTS_DATA_NAME][meta.port_num]
									var key = save_graph[connection_plugs_instr][RIGHT_PORTS_DATA_NAME][meta.port_num].keys()[0]
									
									if plug_big_instr[key] is String:
										continue
											
									var new_co_to_con := new_con_to_con(
										right_port.keys()[0].source_res,plug_big_instr[key][0].source_res,plug_big_instr[key][1].room_
										)
									if room_graph.has(nodes.room_):
										room_graph[nodes.room_].append(new_co_to_con)
									else:
										room_graph[nodes.room_] = [new_co_to_con]

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
							
							print(enter)
							
							enters_location[enter] = value
	
	new_ready_location.rooms_graph = room_graph
	new_ready_location.enters_location = enters_location
	
	return new_ready_location

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
