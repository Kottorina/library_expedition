extends BakerMain

func FromPathDataToBakePathSet(path_data : Variant) -> BakePathSet:
	var bake_path_set = BakePathSet.new()
	
	bake_path_set.ui_category = path_node_const.MusicDataName
	
	return bake_path_set
