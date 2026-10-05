extends BakerGraphDataObject
class_name BakerDialogueGraphDataObject

const START_CHOISE_IND := 3

var data_container : Array[DataContainer]

var obj_to_dialogue_step : Dictionary ## to_obj : int

var current_dialogue : DataDialogue

func bake_node(node : BigGraphNodeMakeInsts) -> void:
	match node.type_node:
		NODE_TYPE.START_AUDIO:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = DialogueStep.Step_Type.StartAudio
			new_step.step_data = GetDataFromCentralData(node,ui_const_func.TOOL_TITLE)
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					break
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			current_dialogue.step_ar.append(new_step)
			obj_to_dialogue_step[node] = new_step
			
		NODE_TYPE.DILOGUE_TO_TOOl:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var last_step : DataStep = GetLastStep(obj_to_dialogue_step,node)
			obj_to_dialogue_step[node] = last_step
		NODE_TYPE.DIALOGUE_EMIT_SIGNAL:
			
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = DialogueStep.Step_Type.EMIT_DIALOGUE
			
			new_step.signal_data = GetDataFromCentralData(node,ui_const_func.EMIT)
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					break
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			current_dialogue.step_ar.append(new_step)
			obj_to_dialogue_step[node] = new_step
			
		NODE_TYPE.DIALOGUE_AWAIT_SIGNAL:
			
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = DialogueStep.Step_Type.AWAIT_DIALOGUE
			
			new_step.signal_data = GetDataFromCentralData(node,ui_const_func.AWAIT_SIGNAL_TITLE)
			new_step.line_data = GetDataFromCentralData(node,ui_const_func.DIALOGUE_TITLE)
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					break
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			current_dialogue.step_ar.append(new_step)
			obj_to_dialogue_step[node] = new_step
			
		NODE_TYPE.START_DIALOGUE:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_dialogue := DataDialogue.new()
			
			new_dialogue.data_name = GetDataFromCentralData(node,ui_const_func.TOOL_TITLE)
			
			save_last_data()
			current_dialogue = new_dialogue
			
			var new_step := DialogueStep.new()
			new_step.step_type = DialogueStep.Step_Type.START_DIALOGUE
			
			current_dialogue.step_ar.append(new_step)
			obj_to_dialogue_step[node] = new_step
			
		NODE_TYPE.DIALOGUE_NODE:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = DialogueStep.Step_Type.MAKE_LINE
			
			new_step.character_data = GetDataFromCentralData(node,ui_const_func.DIALOGUE_CHARACTER_TITLE)
			new_step.line_data = GetDataFromCentralData(node,ui_const_func.DIALOGUE_TITLE)
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					break
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			current_dialogue.step_ar.append(new_step)
			obj_to_dialogue_step[node] = new_step
		
		NODE_TYPE.END_DIALOGUE:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = DataStep.Step_Type.END_DIALOGUE
			
			new_step.signal_data = GetDataFromCentralData(node,ui_const_func.TOOL_TITLE)
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					break
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			current_dialogue.step_ar.append(new_step)
			obj_to_dialogue_step[node] = new_step
			
		NODE_TYPE.DIALOGUE_CHOISE:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = DialogueStep.Step_Type.MAKE_CHOISE
			new_step.next_step_ar = []
			for ind in range(START_CHOISE_IND,central_data_graph[node].size()): ## Пока так, его магические числа
				
				var und_step := DialogueStep.new()
				und_step.step_type = DialogueStep.Step_Type.CHOISE_DIALOGUE
				
				var meta = central_data_graph[node][ind]
				und_step.line_data = meta.instr.body_value
				und_step.signal_data = ind - START_CHOISE_IND
				
				new_step.next_step_ar.append(und_step)
			
			new_step.character_data = GetDataFromCentralData(node,ui_const_func.DIALOGUE_CHARACTER_TITLE)
			new_step.line_data = GetDataFromCentralData(node,ui_const_func.DIALOGUE_TITLE)
			
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
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
			
			current_dialogue.step_ar.append(new_step)
			obj_to_dialogue_step[node] = new_step
		
		NODE_TYPE.DIALOGUE_SETTING:
			
			current_dialogue.is_skiped = GetDataFromCentralData(node,ui_const_func.DIALOGUE_IS_SKIPED_TITLE)
			current_dialogue.after_time = GetDataFromCentralData(node,ui_const_func.DIALOGUE_AFTER_TIME_TITLE)
			current_dialogue.befor_time = GetDataFromCentralData(node,ui_const_func.DIALOGUE_BEFOR_TIME_TITLE)
			current_dialogue.between_character_line_time = GetDataFromCentralData(node,ui_const_func.DIALOGUE_BETWEEN_CHARACTER_TIME_TITLE)
			current_dialogue.char_character_time = GetDataFromCentralData(node,ui_const_func.DIALOGUE_CHAR_CHARACTER_TIME_TITLE)
			current_dialogue.char_line_time = GetDataFromCentralData(node,ui_const_func.DIALOGUE_CHAR_LINE_TIME_TITLE)
		
		NODE_TYPE.NEXT_DIALOGUE:
			var new_step := DialogueStep.new()
			new_step.step_type = DataStep.Step_Type.NEXT_DIALOGUE
			
			new_step.signal_data = GetDataFromCentralData(node,ui_const_func.TOOL_TITLE)
			
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
					break
			
			if last_dialogue_step.step_type != 2: ## ! "make_choise"
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			current_dialogue.step_ar.append(new_step)
			obj_to_dialogue_step[node] = new_step
			
		_:
			var free_port = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port : FromToWith in free_port:
				AddFreePort(port)

func save_last_data() -> void:
	if current_dialogue:
		data_container.append(current_dialogue)
	
func GetFullBakeData() -> Array:
	save_last_data()
	return data_container
