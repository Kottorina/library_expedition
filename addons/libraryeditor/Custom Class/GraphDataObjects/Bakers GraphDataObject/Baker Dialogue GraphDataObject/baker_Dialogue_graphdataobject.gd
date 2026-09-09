extends BakerGraphDataObject
class_name BakerDialogueGraphDataObject

const START_DIALOGUE := 9
const DIALOGUE_NODE := 10
const END_DIALOGUE := 11
const DIALOGUE_CHOICE := 12
const CHOISE_DIALOGUE := 13

const START_CHOISE_IND := 1

const DIALOGUE_SET : String = "dialogue_set"

var dialogue_set : Dictionary

var obj_to_dialogue_step : Dictionary ## to_obj : int

var last_dialogue_set_name : String

func bake_node(nodes : BigGraphNodeMakeInsts) -> void:
	match nodes.type_node:
		START_DIALOGUE:
			var free_ports = get_free_ports(save_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var data_meta_ar : Array[GraphNodeMetadata] = central_data_graph[nodes]
			for data in data_meta_ar:
				if data.instr.title_instr == ui_const_func.TOOL_TITLE:
					last_dialogue_set_name = data.instr.body_value
			
			var new_step := DialogueStep.new()
			new_step.step_type = 0
			
			dialogue_set[last_dialogue_set_name] = [new_step]
			obj_to_dialogue_step[nodes] = new_step
			
		DIALOGUE_NODE:
			var free_ports = get_free_ports(save_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = 1
			
			var data_meta_ar : Array[GraphNodeMetadata] = central_data_graph[nodes]
			for data in data_meta_ar:
				if data.instr.title_instr == ui_const_func.DIALOGUE_CHARACTER_TITLE:
					new_step.character_data = data.instr.body_value
				elif data.instr.title_instr == ui_const_func.DIALOGUE_TITLE:
					new_step.dialogue_data = data.instr.body_value
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					continue
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			dialogue_set[last_dialogue_set_name].append(new_step)
			obj_to_dialogue_step[nodes] = new_step
		
		END_DIALOGUE:
			var free_ports = get_free_ports(save_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = 3
			
			var data_meta_ar : Array[GraphNodeMetadata] = central_data_graph[nodes]
			for data in data_meta_ar:
				if data.instr.title_instr == ui_const_func.TOOL_TITLE:
					new_step.signal_data = data.instr.body_value
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					continue
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			dialogue_set[last_dialogue_set_name].append(new_step)
			obj_to_dialogue_step[nodes] = new_step
			
		DIALOGUE_CHOICE:
			var free_ports = get_free_ports(save_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = 2
			new_step.next_step_ar = []
			for ind in range(START_CHOISE_IND,central_data_graph[nodes].size()): ## Пока так, его магические числа
				
				var und_step := DialogueStep.new()
				und_step.step_type = CHOISE_DIALOGUE
				
				var meta = central_data_graph[nodes][ind]
				und_step.dialogue_data = meta.instr.body_value
				und_step.signal_data = ind - START_CHOISE_IND
				
				dialogue_set[last_dialogue_set_name].append(und_step)
				new_step.next_step_ar.append(und_step)
			
			var data_meta_ar : Array[GraphNodeMetadata] = central_data_graph[nodes]
			for data in data_meta_ar:
				if data.instr.title_instr == ui_const_func.DIALOGUE_CHOISE_TITLE:
					new_step.character_data = data.instr.body_value
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					continue
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			dialogue_set[last_dialogue_set_name].append(new_step)
			obj_to_dialogue_step[nodes] = new_step
			
			#if not full_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME].size() == full_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME].size():
				#return
			#
			#var node_data : String
			#var last_dialogue_step : DialogueStep
			#var last_dialogue_port_num : int
			#
			#var ports = full_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME]
			#for port : FromToWith in ports:
				#if port.from_data.instr.title_instr == ui_const_func.DIALOGUE_CHOISE_TITLE:
					#node_data = port.from_data.instr.body_value
				#if obj_to_dialogue_step.has(port.to_obj):
					#last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					#last_dialogue_port_num = port.to_data.port_num
				#else:
					#AddFreePort(port)
			#
			#var new_step := DialogueStep.new()
			#new_step.step_type = 2
			#new_step.step_data = node_data
			#new_step.next_step_ar = []
			#
			#for ind in range(1,full_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME].size()): ## Пока так, его магические числа
				#
				#var und_step := DialogueStep.new()
				#und_step.step_type = CHOISE_DIALOGUE
				#
				#var port = full_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME][ind]
				#
				#und_step.step_data = port.from_data.instr.body_value
				#
				#dialogue_set[last_dialogue_set_name].append(und_step)
				#
				#new_step.next_step_ar.append(und_step)
				#
			#
			#if last_dialogue_step.step_type != 2:
				#last_dialogue_step.next_step_ar = [new_step]
			#else:
				#var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				#real_last_step.next_step_ar.append(new_step)
			#
			#dialogue_set[last_dialogue_set_name].append(new_step)
			#
			#obj_to_dialogue_step[nodes] = new_step
			
		_:
			last_dialogue_set_name = ""
			var free_port = get_free_ports(save_graph[nodes][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[nodes][graph_const.RIGHT_PORTS_DATA_NAME])
			for port : FromToWith in free_port:
				AddFreePort(port)

#var free_port = get_free_ports(save_graph[nodes][LEFT_PORTS_DATA_NAME] + save_graph[nodes][RIGHT_PORTS_DATA_NAME])

func last_bake_call() -> void:
	
	for ar in dialogue_set:
		print(dialogue_set[ar].size())
	print(dialogue_set)
	bake_data_dict[DIALOGUE_SET] = dialogue_set
