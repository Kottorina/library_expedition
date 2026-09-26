extends Resource
class_name BakerMain

var ui_const_func := UiConstFunc.new()
var path_node_const := PathNodeConst.new()

const ROOMNODENAME = "Room Node: "
const ROOMS_UI_LOCATIONS : String = "Locations"

func bake_ui(graph_data_objects_ar : Array) -> GraphDataObjectsUiSet:
	## graph_data_objects_ar : Array[GraphDataObjects]
	var new_graph_data_obj_ui_set := GraphDataObjectsUiSet.new()
	new_graph_data_obj_ui_set.ui_category = ROOMS_UI_LOCATIONS
	
	#var callable = Callable(self, "from_GraphDataObjects_to_BigGraphNodeMakeInsts")
	#if not callable.is_valid():
		#return
	#
	#for obj_ind in graph_data_objects_ar.size():
		#var current_obj = graph_data_objects_ar[obj_ind]
		#if current_obj != null:
			#var name_item : String = ROOMNODENAME + current_obj.name_+" "+str(obj_ind)
			#var big_instr : BigGraphNodeMakeInsts = callable.call(current_obj)
			#big_instr.title_node = name_item
			#big_instr.graph_data_object = current_obj
			#
			#new_graph_data_obj_ui_set.biginstr_ar.append(big_instr)
	
	return new_graph_data_obj_ui_set

func bake_path_data(path_data : Variant) -> BakePathSet:
	var callable = Callable(self, "FromPathDataToBakePathSet")
	if not callable.is_valid():
		return null
	
	return callable.call(path_data)
