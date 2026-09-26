extends BakerGraphDataObject
class_name BakerAudioGraphDataObject

var audio_set : Dictionary
var current_audio : DataAudio

var obj_to_step : Dictionary

const AUDIO_SET : String = "AudioDataSet"

func bake_node(node : BigGraphNodeMakeInsts) -> void:
	match node.type_node:
		NODE_TYPE.START_AUDIO:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			save_last_dialogue()
			current_audio = DataAudio.new()
			current_audio.audio_name = GetDataFromCentralData(node,ui_const_func.TOOL_TITLE)
			
			var step = AudioStep.new()
			step.step_type = AudioStep.Step_Type.StartAudio
			
			current_audio.step_audio_ar.append(step)
			obj_to_step[node] = step
			
		NODE_TYPE.AUDIO_TIMER:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var step = AudioStep.new()
			step.step_type = AudioStep.Step_Type.Timer_
			step.step_data = GetDataFromCentralData(node,ui_const_func.AUDIO_TIMER_TITLE)
			
			current_audio.step_audio_ar.append(step)
			obj_to_step[node] = step
			
			var last_step : AudioStep
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_step.has(port.to_obj):
					last_step = obj_to_step[port.to_obj]
			last_step.next_step_ar.append(step)
			
		NODE_TYPE.AUDIO_END:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var step = AudioStep.new()
			step.step_type = AudioStep.Step_Type.EndAudio
			step.step_data = GetDataFromCentralData(node,ui_const_func.AUDIO_TIMER_TITLE)
			
			current_audio.step_audio_ar.append(step)
			obj_to_step[node] = step
			
			var last_step : AudioStep
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_step.has(port.to_obj):
					last_step = obj_to_step[port.to_obj]
			last_step.next_step_ar.append(step)
			
		NODE_TYPE.AUDIO_CROSSROAD:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var last_step : AudioStep
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_step.has(port.to_obj):
					last_step = obj_to_step[port.to_obj]
			obj_to_step[node] = last_step
		NODE_TYPE.MAKE_AUDIO:
			
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var step = AudioStep.new()
			step.step_type = AudioStep.Step_Type.MakeAudioOnce
			step.step_data = GetDataFromCentralData(node,ui_const_func.AUDIO_DATA_TITLE)
			current_audio.step_audio_ar.append(step)
			
			var last_step : AudioStep
			var ports = full_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + full_graph[node][graph_const.RIGHT_PORTS_DATA_NAME]
			for port : FromToWith in ports:
				if obj_to_step.has(port.to_obj):
					last_step = obj_to_step[port.to_obj]
			last_step.next_step_ar.append(step)
		_:
			current_audio == null
			var free_port = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port : FromToWith in free_port:
				AddFreePort(port)

func save_last_dialogue() -> void:
	if current_audio:
		audio_set[current_audio.audio_name] = current_audio

func last_bake_call() -> void:
	save_last_dialogue()
	print(audio_set["BestSong"].step_audio_ar)
	bake_data_dict[AUDIO_SET] = audio_set
