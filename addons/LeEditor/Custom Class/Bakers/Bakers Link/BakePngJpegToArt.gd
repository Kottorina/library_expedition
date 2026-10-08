extends BakerMain

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

func FromPathDataToPreview(path_data : Variant) -> LeFile:
	var dir = DirAccess.open(path_data)
	if !dir:
		return 
	var preview_ar : Array[String] = []
	var files_name = dir.get_files()
	for file_name in files_name:
		if file_name.ends_with(".jpeg") or file_name.ends_with(".png"):
			var full_path = path_data.path_join(file_name)
			var file := FileAccess.open(full_path, FileAccess.READ)
			preview_ar.append(file_name)
	
	var data_cont = LeFile.new()
	data_cont.data = preview_ar
	
	return data_cont

func FromPathDataToImport(path_data : Variant) -> LeFile:
	var dir = DirAccess.open(path_data)
	if !dir:
		return 
	var import_ar : Array[Image] = []
	var files_name = dir.get_files()
	for file_name in files_name:
		if file_name.ends_with(".jpeg") or file_name.ends_with(".png") or file_name.ends_with(".jpg"):
			var full_path = path_data.path_join(file_name)
			var file := FileAccess.open(full_path, FileAccess.READ)
			
			var godo_art := Image.new()
			var error := godo_art.load(full_path)
			if error != OK:
				continue
			godo_art.resource_name = file_name
				
			import_ar.append(godo_art)
	
	var data_cont = LeFile.new()
	data_cont.data = import_ar
	
	return data_cont
