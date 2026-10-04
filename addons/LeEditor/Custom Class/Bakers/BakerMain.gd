extends Resource
class_name BakerMain

var ui_const_func := UiConstFunc.new()
var path_node_const := PathNodeConst.new()

const NODE_TYPE = BigGraphNodeMakeInsts.NodeType

const ROOMNODENAME = "Room Node: "
const ROOMS_UI_LOCATIONS : String = "Locations"

func BakeUi(objects_ar : Array, category : String) -> Array:
	
	var callable = Callable(self, "FromObjectToBigInstr")
	if not callable.is_valid():
		return []
	
	var big_instr_ar : Array[BigGraphNodeMakeInsts]
	
	for obj in objects_ar:
		var big_instr : Array[BigGraphNodeMakeInsts] = callable.call(obj, category)
		big_instr_ar.append_array(big_instr)
	
	return big_instr_ar
	
func BakePathDataPreview(path_data : Variant) -> LeFile:
	var callable = Callable(self, "FromPathDataToPreview")
	if not callable.is_valid():
		return null
	return callable.call(path_data)

func BakePathDataImport(path_data : Variant) -> LeFile:
	var callable = Callable(self, "FromPathDataToImport")
	if not callable.is_valid():
		return null
	return callable.call(path_data)
