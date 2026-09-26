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

func FromObjectToBigInstr(obj : Variant) -> BigGraphNodeMakeInsts:
	
