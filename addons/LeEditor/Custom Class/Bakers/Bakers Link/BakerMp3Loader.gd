extends BakerMain

func FromPathDataToPreview(path_data : Variant) -> LeFile:
	if typeof(path_data) != TYPE_STRING:
		push_warning("dir_path Is Not String")
		return 
	var dir = DirAccess.open(path_data)
	if !dir:
		return 
	var mp3_preview_ar : Array[String] = []
	var files_name = dir.get_files()
	for file_name in files_name:
		if file_name.ends_with(".mp3"):
			var full_path = path_data.path_join(file_name)
			var file := FileAccess.open(full_path, FileAccess.READ)
			mp3_preview_ar.append(file_name)
	
	var data_cont = LeFile.new()
	data_cont.data = mp3_preview_ar
	
	return data_cont

func FromPathDataToImport(path_data : Variant) -> LeFile:
	if typeof(path_data) != TYPE_STRING:
		push_warning("dir_path Is Not String")
		return 
	var dir = DirAccess.open(path_data)
	if !dir:
		return 
	var mp3_import_ar : Array[AudioStream] = []
	var files_name = dir.get_files()
	for file_name in files_name:
		if file_name.ends_with(".mp3"):
			var full_path = path_data.path_join(file_name)
			var file := FileAccess.open(full_path, FileAccess.READ)
			
			var audio_stream := AudioStreamMP3.new()
			audio_stream.resource_name = file_name
			audio_stream.data = file.get_buffer(file.get_length())

			mp3_import_ar.append(audio_stream)
	
	var data_cont = LeFile.new()
	data_cont.data = mp3_import_ar
	
	return data_cont

func FromObjectToBigInstr(obj : LeFile, category : String) -> Array[BigGraphNodeMakeInsts]:
	if obj is not LeFile:
		return []
	var big_instr_ar : Array[BigGraphNodeMakeInsts]
	var ind : int = 0
	for name_mp3 : String in obj.data:
		var big_instr = BigGraphNodeMakeInsts.new()
		big_instr.title_node = (ui_const_func.AUDIO_STREAM_MP3_BIG_TITLE + name_mp3)
		big_instr.type_node = NODE_TYPE.MAKE_AUDIO
		
		big_instr.ui_category = category
	
		var instr = ui_const_func.GetCloseAudioData()
		var path_to_data := PathToData.new()
		path_to_data.category = category
		path_to_data.id = obj.id_
		path_to_data.id_in_ar = ind
		instr.body_value = path_to_data
		big_instr.instr_ar.append(instr)
	
		big_instr.instr_ar.append(ui_const_func.GetOpenAudioConnector())
		
		var instr_0 = ui_const_func.GetOpenAudioConnector()
		instr_0.title_instr = ui_const_func.AUDIO_AWAIT_TIMEOUT
		big_instr.instr_ar.append(instr_0)
		
		big_instr_ar.append(big_instr)
		
		ind+= 1
	
	return big_instr_ar
