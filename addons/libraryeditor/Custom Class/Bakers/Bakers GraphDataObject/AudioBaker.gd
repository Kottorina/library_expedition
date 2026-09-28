extends BakerGraphDataObject
class_name BakerAudioGraphDataObject


var data_container : Array[DataContainer]
var current_audio : DataContainer

var obj_to_step : Dictionary

func bake_node(node : BigGraphNodeMakeInsts) -> void:
	match node.type_node:
		NODE_TYPE.START_AUDIO:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			save_last_data()
			current_audio = DataContainer.new()
			current_audio.data_name = GetDataFromCentralData(node,ui_const_func.TOOL_TITLE)
			
			var step = DataStep.new()
			step.step_type = DataStep.Step_Type.StartAudio
			
			current_audio.step_ar.append(step)
			obj_to_step[node] = step
			
		NODE_TYPE.AUDIO_TIMER:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var timeout_time : float = 0
			
			var await_timeout = GetLastStep(obj_to_step,node,ui_const_func.AUDIO_AWAIT_TIMEOUT)
			if await_timeout != null:
				timeout_time = await_timeout.step_data.get_length() ## ПОТОМУ ЧТО ТАМ AudioStreamMp3
			
			var step = DataStep.new()
			step.step_type = DataStep.Step_Type.Timer_
			step.step_data = timeout_time + GetDataFromCentralData(node,ui_const_func.AUDIO_TIMER_TITLE)
			
			current_audio.step_ar.append(step)
			
			var last_step : DataStep = GetLastStep(obj_to_step,node)
			last_step.next_step_ar.append(step)
			obj_to_step[node] = step
			
		NODE_TYPE.AUDIO_END:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var step = DataStep.new()
			step.step_type = DataStep.Step_Type.EndAudio
			step.step_data = GetDataFromCentralData(node,ui_const_func.AUDIO_TIMER_TITLE)
			
			current_audio.step_ar.append(step)
			obj_to_step[node] = step
			
			var last_step : DataStep = GetLastStep(obj_to_step,node)
			last_step.next_step_ar.append(step)
			obj_to_step[node] = step
			
		NODE_TYPE.AUDIO_CROSSROAD:
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var last_step : DataStep = GetLastStep(obj_to_step,node)
			obj_to_step[node] = last_step
		NODE_TYPE.MAKE_AUDIO:
			
			var free_ports = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port in free_ports:
				AddFreePort(port)
			
			var step = DataStep.new()
			step.step_type = DataStep.Step_Type.PlayAudio
			step.step_data = GetDataFromCentralData(node,ui_const_func.AUDIO_DATA_TITLE)
			current_audio.step_ar.append(step)
			
			var last_step : DataStep = GetLastStep(obj_to_step,node)
			last_step.next_step_ar.append(step)
			obj_to_step[node] = step
		_:
			current_audio == null
			var free_port = get_free_ports(save_graph[node][graph_const.LEFT_PORTS_DATA_NAME] + save_graph[node][graph_const.RIGHT_PORTS_DATA_NAME])
			for port : FromToWith in free_port:
				AddFreePort(port)



func save_last_data() -> void:
	if current_audio:
		data_container.append(current_audio)

func GetFullBakeData() -> Array:
	save_last_data()
	return data_container
