extends BakerMain

func FromPathDataToBakePathSet(path_data : Variant) -> BakePathSet:
	var bake_path_set = BakePathSet.new()
	
	bake_path_set.ui_category = GetUiCategory()
	
	var data_cont = PathLibraryObject.new()
	
	data_cont.data = GetMp3FromDir(path_data)
	
	bake_path_set.path_library_object = data_cont
	
	return bake_path_set

func GetUiCategory() -> String:
	return path_node_const.MusicDataName

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

func FromObjectToBigInstr(obj : Variant) -> Array[BigGraphNodeMakeInsts]:
	
	if obj is not PathLibraryObject:
		return []
	
	var big_instr_ar : Array[BigGraphNodeMakeInsts]
	
	for mp3 : AudioStreamMP3 in obj.data:
		#print(mp3.resource_name)
		var big_instr = BigGraphNodeMakeInsts.new()
		big_instr.title_node = (ui_const_func.AUDIO_STREAM_MP3_BIG_TITLE + mp3.resource_name)
		big_instr.type_node = NODE_TYPE.MAKE_AUDIO
		
		big_instr.ui_category = GetUiCategory()
	
		var instr = ui_const_func.GetCloseAudioData()
		instr.body_value = mp3
		big_instr.instr_ar.append(instr)
	
		big_instr.instr_ar.append(ui_const_func.GetOpenAudioConnector())
		
		var instr_0 = ui_const_func.GetOpenAudioConnector()
		instr_0.title_instr = ui_const_func.AUDIO_AWAIT_TIMEOUT
		big_instr.instr_ar.append(instr_0)
		
		big_instr_ar.append(big_instr)
	
	return big_instr_ar
