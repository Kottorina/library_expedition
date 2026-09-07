extends BakerGraphDataObject
class_name BakerDialogueGraphDataObject

const START_DIALOGUE := 9
const DIALOGUE_NODE := 10
const END_DIALOGUE := 11
const DIALOGUE_CHOICE := 12

const DIALOGUE_SET : String = "dialogue_set"

var dialogue_set : Dictionary

var last_dialogue_step : DialogueStep
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
			
			last_dialogue_step = new_step
			
		DIALOGUE_NODE:
			
			var node_data : String
			
			var free_port = get_free_ports(save_graph[nodes][LEFT_PORTS_DATA_NAME] + save_graph[nodes][RIGHT_PORTS_DATA_NAME])
			for port : FromToWith in free_port:
				if port.from_data.instr.title_instr == ui_const_func.DIALOGUE_TITLE:
					node_data = port.from_data.instr.body_value
				AddFreePort(port)
			
			var new_step := DialogueStep.new()
			new_step.step_type = 1
			new_step.step_data = node_data
			
			if last_dialogue_step.step_type != 2:
				last_dialogue_step.next_step_ar = [new_step]
			
			dialogue_set[last_dialogue_set_name].append(new_step)
			last_dialogue_step = new_step
		
		END_DIALOGUE:
			
			var node_data : String
			
			var ports = save_graph[nodes][LEFT_PORTS_DATA_NAME] + save_graph[nodes][RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if port.from_data.instr.title_instr == ui_const_func.TOOL_TITLE:
					node_data = port.from_data.instr.body_value
			
			var new_step := DialogueStep.new()
			new_step.step_type = 3
			new_step.step_data = node_data
			
			if last_dialogue_step.step_type != 2:
				last_dialogue_step.next_step_ar = [new_step]
			
			dialogue_set[last_dialogue_set_name].append(new_step)
			
		DIALOGUE_CHOICE:
			pass
		_:
			last_dialogue_set_name = ""
			var free_port = get_free_ports(save_graph[nodes][LEFT_PORTS_DATA_NAME] + save_graph[nodes][RIGHT_PORTS_DATA_NAME])
			for port : FromToWith in free_port:
				AddFreePort(port)

func last_bake_call() -> void:
	print(dialogue_set)
	bake_data_dict[DIALOGUE_SET] = dialogue_set
