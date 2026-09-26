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
		
		print(mp3.resource_name)
		
		var big_instr = BigGraphNodeMakeInsts.new()
		big_instr.title_node = (ui_const_func.AUDIO_STREAM_MP3_BIG_TITLE + mp3.resource_name)
		big_instr.type_node = 17
		
		big_instr.ui_category = GetUiCategory()
		
		var tool_instr = GraphNodeMakeInsts.new()
		tool_instr.title_instr = ui_const_func.AUDIO_TITLE
		
		tool_instr.is_right = true
		tool_instr.right_type = ui_const_func.TOOL_AUDIO_TYPE_CON
		tool_instr.right_color = ui_const_func.TOOL_AUDIO_COLOR_CON
		tool_instr.is_left = true
		tool_instr.left_type = ui_const_func.TOOL_AUDIO_TYPE_CON
		tool_instr.left_color = ui_const_func.TOOL_AUDIO_COLOR_CON
		big_instr.instr_ar.append(tool_instr)
		
		big_instr_ar.append(big_instr)
	
	return big_instr_ar
