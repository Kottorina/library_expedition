extends BakerGraphDataObject
class_name BakerDialogueGraphDataObject

const START_DIALOGUE := 9
const DIALOGUE_NODE := 10
const END_DIALOGUE := 11
const DIALOGUE_CHOICE := 12
const CHOISE_DIALOGUE := 13

const DIALOGUE_SET : String = "dialogue_set"

var dialogue_set : Dictionary

var obj_to_dialogue_step : Dictionary ## to_obj : int

var last_dialogue_set_name : String

func bake_node(nodes : BigGraphNodeMakeInsts) -> void:
	match nodes.type_node:
		START_DIALOGUE:
			
			var ports = save_graph[nodes][LEFT_PORTS_DATA_NAME] + save_graph[nodes][RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if port.from_data.instr.title_instr == ui_const_func.TOOL_TITLE:
					last_dialogue_set_name = port.from_data.instr.body_value
				
				if IsPortFree(port) == true:
					AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = 0
			
			dialogue_set[last_dialogue_set_name] = [new_step]
			
			obj_to_dialogue_step[nodes] = new_step
			
		DIALOGUE_NODE:
			
			var node_data : String
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[nodes][LEFT_PORTS_DATA_NAME] + full_graph[nodes][RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if port.from_data.instr.title_instr == ui_const_func.DIALOGUE_TITLE:
					node_data = port.from_data.instr.body_value
					if obj_to_dialogue_step.has(port.to_obj):
						last_dialogue_step = obj_to_dialogue_step[port.to_obj]
						last_dialogue_port_num = port.to_data.port_num
					else:
						AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = 1
			new_step.step_data = node_data
			
			if last_dialogue_step.step_type != 2:
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			dialogue_set[last_dialogue_set_name].append(new_step)
			
			obj_to_dialogue_step[nodes] = new_step
		
		END_DIALOGUE:

			var node_data : String
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[nodes][LEFT_PORTS_DATA_NAME] + full_graph[nodes][RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if port.from_data.instr.title_instr == ui_const_func.TOOL_TITLE:
					node_data = port.from_data.instr.body_value
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
			
			
			var new_step := DialogueStep.new()
			new_step.step_type = 3
			new_step.step_data = node_data
			
			if last_dialogue_step.step_type != 2:
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)

			dialogue_set[last_dialogue_set_name].append(new_step)
			
		DIALOGUE_CHOICE:
			
			if not full_graph[nodes][LEFT_PORTS_DATA_NAME].size() == full_graph[nodes][RIGHT_PORTS_DATA_NAME].size():
				return
			
			var node_data : String
			var last_dialogue_step : DialogueStep
			var last_dialogue_port_num : int
			
			var ports = full_graph[nodes][LEFT_PORTS_DATA_NAME] + full_graph[nodes][RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if port.from_data.instr.title_instr == ui_const_func.DIALOGUE_CHOISE_TITLE:
					node_data = port.from_data.instr.body_value
				if obj_to_dialogue_step.has(port.to_obj):
					last_dialogue_step = obj_to_dialogue_step[port.to_obj]
					last_dialogue_port_num = port.to_data.port_num
				else:
					AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = 2
			new_step.step_data = node_data
			new_step.next_step_ar = []
			
			for ind in range(1,full_graph[nodes][LEFT_PORTS_DATA_NAME].size()): ## Пока так, его магические числа
				
				var und_step := DialogueStep.new()
				und_step.step_type = CHOISE_DIALOGUE
				
				var port = full_graph[nodes][LEFT_PORTS_DATA_NAME][ind]
				
				und_step.step_data = port.from_data.instr.body_value
				
				new_step.next_step_ar.append(und_step)
				
			
			if last_dialogue_step.step_type != 2:
				last_dialogue_step.next_step_ar = [new_step]
			else:
				var real_last_step = last_dialogue_step.next_step_ar[last_dialogue_port_num-1] 
				real_last_step.next_step_ar.append(new_step)
			
			dialogue_set[last_dialogue_set_name].append(new_step)
			
			obj_to_dialogue_step[nodes] = new_step
			
		_:
			last_dialogue_set_name = ""
			var free_port = get_free_ports(save_graph[nodes][LEFT_PORTS_DATA_NAME] + save_graph[nodes][RIGHT_PORTS_DATA_NAME])
			for port : FromToWith in free_port:
				AddFreePort(port)

#var free_port = get_free_ports(save_graph[nodes][LEFT_PORTS_DATA_NAME] + save_graph[nodes][RIGHT_PORTS_DATA_NAME])

func last_bake_call() -> void:
	print(dialogue_set)
	bake_data_dict[DIALOGUE_SET] = dialogue_set
