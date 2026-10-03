extends BakerMain

func FromPathDataToBakePathSet(path_data : Variant, category : String) -> BakePathSet:
	var bake_path_set = BakePathSet.new()
	
	bake_path_set.ui_category = category
	
	var data_cont = LeFile.new()
	
	data_cont.data = GetMp3FromDir(path_data)
	
	bake_path_set.path_library_object = data_cont
	
	return bake_path_set

func GetMp3FromDir(dir_path : Variant) -> Array:
	
	if typeof(dir_path) != TYPE_STRING:
		return []
	
	var dir = DirAccess.open(dir_path)
	if !dir:
		return []
	
	var mp3_ar = []
	
	var files_name = dir.get_files()
	for file_name in files_name:
		if file_name.ends_with(".mp3"):
			#print(file_name)
			var full_path = dir_path.path_join(file_name)
			var file := FileAccess.open(full_path, FileAccess.READ)
			
			var godo_mp3 := AudioStreamMP3.new()
			godo_mp3.data = file.get_buffer(file.get_length())
			godo_mp3.resource_name = file_name
			
			mp3_ar.append(godo_mp3)

	return mp3_ar

func FromObjectToBigInstr(obj : LeFile, category : String) -> Array[BigGraphNodeMakeInsts]:
	
	if obj is not LeFile:
		return []
	
	var big_instr_ar : Array[BigGraphNodeMakeInsts]
	
	var ind : int = 0
	for mp3 : AudioStreamMP3 in obj.data:
		#print(mp3.resource_name)
		var big_instr = BigGraphNodeMakeInsts.new()
		big_instr.title_node = (ui_const_func.AUDIO_STREAM_MP3_BIG_TITLE + mp3.resource_name)
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
