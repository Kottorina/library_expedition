extends Node

func BakePath(path_ar : Array[PathNode], path_to_base_file_system : String) -> void:
	
	var import_files := LeFileSystem.new()
	import_files.resource_name = PathNodeConst.ImportLeFileSystemName + path_to_base_file_system.get_file()
	
	for path_node : PathNode in path_ar:
		var path_data : LeFile
	
		var baker_class = path_node.baker_object_script_path
		if baker_class != null:
			var ready_baker : BakerMain = baker_class.new()
			path_data = ready_baker.BakePathDataImport(path_node.path_data)
			if path_data == null:
				push_warning("bake_path_set Id Null!")
				continue
		else:
			push_warning("Baker for "+ path_node.data_key+" not find!")
			continue
		
		import_files.AddNewObjInArray(
			path_node.data_key,
			path_data,
			path_node.id_
		)
	
	
	var path_save : String = path_to_base_file_system.get_base_dir()+"/"+import_files.resource_name
	var error := ResourceSaver.save(import_files, path_save)

	print("Save path: ", path_save)
	print("Save error: ", error)
	print("File exists: ", FileAccess.file_exists(path_save))
