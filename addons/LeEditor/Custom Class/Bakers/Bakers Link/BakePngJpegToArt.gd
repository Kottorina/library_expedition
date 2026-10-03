extends BakerMain

func FromPathDataToBakePathSet(path_data : Variant, category : String) -> BakePathSet:
	var bake_path_set = BakePathSet.new()
	
	bake_path_set.ui_category = category
	
	var data_cont = LeFile.new()
	
	data_cont.data = GetArtFromDir(path_data)
	
	bake_path_set.path_library_object = data_cont
	
	return bake_path_set
	
func GetArtFromDir(dir_path : Variant) -> Array:
	
	if typeof(dir_path) != TYPE_STRING:
		return []
	
	var dir = DirAccess.open(dir_path)
	if !dir:
		return []
	
	var art_ar = []
	
	var files_name = dir.get_files()
	for file_name in files_name:
		
		#if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
			#print(file_name)
		var full_path = dir_path.path_join(file_name)
		
		var godo_art := Image.new()
		var error := godo_art.load(full_path)
		if error != OK:
			continue
		godo_art.resource_name = file_name
			
		art_ar.append(godo_art)
	return art_ar
